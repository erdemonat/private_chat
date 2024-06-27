import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:privatechat/components/delete_account_button.dart';
import 'package:privatechat/components/profile_avatar.dart';
import 'package:privatechat/components/user_info_list.dart';
import 'package:privatechat/theme/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var db = FirebaseFirestore.instance;
  final authenticatedUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: kAppbarTitle),
        backgroundColor: Colors.transparent,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: StreamBuilder(
        stream: db.collection('users').doc(authenticatedUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: RefreshProgressIndicator());
          }

          final _userEmail = authenticatedUser.email ?? '';
          final _userData = snapshot.data!.data()!;
          final _username = _userData['username'] ?? 'Unknown';
          final _userStatus = _userData['status'] ?? 'No status';
          final _userImage = _userData['image_url'] ?? '';

          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  ProfileAvatar(
                    imageUrl: _userImage,
                    onUpdatePhoto: () => _updatePhoto(context),
                  ),
                  const SizedBox(height: 32),
                  UserInfoList(
                    username: _username,
                    status: _userStatus,
                    email: _userEmail,
                    onUpdateUsername: (updatedModel) async {
                      await db
                          .collection('users')
                          .doc(authenticatedUser.uid)
                          .update({'username': updatedModel.subTitle});
                    },
                    onUpdateStatus: (updatedModel) async {
                      await db
                          .collection('users')
                          .doc(authenticatedUser.uid)
                          .update({'status': updatedModel.subTitle});
                    },
                    onUpdateEmail: (updatedModel) async {
                      await _updateEmail(updatedModel.subTitle);
                    },
                  ),
                  DeleteAccountButton(
                    onDelete: _deleteAccount,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String?> _promptForPassword(BuildContext context) async {
    TextEditingController _passwordController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Confirm permanent deletion of user info, image, and messages?',
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary, fontSize: 16),
        ),
        content: TextField(
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          controller: _passwordController,
          decoration: const InputDecoration(hintText: 'Verify password'),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text('Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.tertiary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _passwordController.text),
            child: Text('Confirm',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.tertiary)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateEmail(String newEmail) async {
    String? password = await _promptForPassword(context);
    if (password == null || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is required to update email')),
      );
      return;
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: authenticatedUser.email!,
        password: password,
      );

      await authenticatedUser.reauthenticateWithCredential(credential);
      await authenticatedUser.verifyBeforeUpdateEmail(newEmail);
      await FirebaseAuth.instance.currentUser!.reload();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update email: $e')),
      );
    }
  }

  Future<void> _updatePhoto(BuildContext context) async {
    final picker = ImagePicker();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 400,
        maxWidth: 400,
      );

      if (pickedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
        return;
      }

      final File imageFile = File(pickedFile.path);

      final storageRef =
          FirebaseStorage.instance.ref().child('user_photos').child(user.uid);

      await storageRef.putFile(imageFile);
      final newPhotoUrl = await storageRef.getDownloadURL();

      await db
          .collection('users')
          .doc(user.uid)
          .update({'image_url': newPhotoUrl});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile photo: $e')),
      );
    }
  }

  Future<void> _deleteUserChats(String userId) async {
    QuerySnapshot userChatsSnapshot = await db
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    for (QueryDocumentSnapshot doc in userChatsSnapshot.docs) {
      // Delete subcollections first
      await _deleteSubcollections(doc.reference);
      // Then delete the document
      await doc.reference.delete();
    }
  }

  Future<void> _deleteSubcollections(DocumentReference docRef) async {
    // Get all subcollections of the document
    var subcollections = await docRef.collection('messages').get();

    for (var subDoc in subcollections.docs) {
      await subDoc.reference.delete();
    }
  }

  Future<void> _deleteAccount() async {
    String? password = await _promptForPassword(context);
    if (password == null || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is required to delete account')),
      );
      return;
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: authenticatedUser.email!,
        password: password,
      );

      await authenticatedUser.reauthenticateWithCredential(credential);
      await FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child(authenticatedUser.uid)
          .delete();

      await db.collection('users').doc(authenticatedUser.uid).delete();
      await _deleteUserChats(authenticatedUser.uid);
      await authenticatedUser.delete();

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed delete account: $e')),
      );
    }
  }
}
