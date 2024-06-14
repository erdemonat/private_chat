import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:privatechat/constants.dart';
import 'package:privatechat/model/my_list_tile_model.dart';
import 'package:privatechat/screens/auth.dart';
import 'package:privatechat/util/my_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

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
        title: Text(
          'Profile',
          style: kTitleText,
        ),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong.'),
            );
          }

          // Firestore'dan kullanıcı verilerini alın.
          final _userEmail = authenticatedUser.email!;
          final _username = snapshot.data!.data()!['username'];
          final _userStatus = snapshot.data!.data()!['status'];
          final _userImage = snapshot.data!.data()!['image_url'];

          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 79,
                        child: ClipOval(
                          child: Image.network(
                            _userImage,
                            fit: BoxFit.cover,
                            width: 158,
                            height: 158,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        child: IconButton(
                            onPressed: () => _updatePhoto(context),
                            icon: const Icon(
                              Icons.add,
                              size: 25,
                            )),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Column(
                      children: [
                        EditableListTile(
                          model:
                              ListModel(title: 'Username', subTitle: _username),
                          onChanged: (updatedModel) async {
                            // Kullanıcı adını Firestore'da güncelle.
                            await db
                                .collection('users')
                                .doc(authenticatedUser.uid)
                                .update({'username': updatedModel.subTitle});
                          },
                        ),
                        EditableListTile(
                          model:
                              ListModel(title: 'Status', subTitle: _userStatus),
                          onChanged: (updatedModel) async {
                            // Kullanıcı adını Firestore'da güncelle.
                            await db
                                .collection('users')
                                .doc(authenticatedUser.uid)
                                .update({'status': updatedModel.subTitle});
                          },
                        ),
                        EditableListTile(
                          model:
                              ListModel(title: 'Email', subTitle: _userEmail),
                          onChanged: (updatedModel) async {
                            await _updateEmail(updatedModel.subTitle);
                          },
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: TextButton(
                      onPressed: () {
                        _deleteAccount();
                      },
                      child: const Text('Delete account'),
                    ),
                  )
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
        title: const Text('Re-enter your password'),
        content: TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            hintText: 'Password',
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _passwordController.text),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateEmail(String newEmail) async {
    // Kullanıcıdan mevcut şifresini al
    String? password = await _promptForPassword(context);
    if (password == null || password.isEmpty) {
      // Kullanıcı şifre girmemişse işlemi iptal et
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is required to update email')),
      );
      return;
    }

    try {
      // Kullanıcıyı mevcut şifresiyle yeniden kimlik doğrulama
      AuthCredential credential = EmailAuthProvider.credential(
        email: authenticatedUser.email!,
        password: password,
      );

      await authenticatedUser.reauthenticateWithCredential(credential);

      // Firebase Authentication'daki e-posta adresini güncelle
      await authenticatedUser.verifyBeforeUpdateEmail(newEmail);

      // Oturumu yenileme
      await FirebaseAuth.instance.currentUser!.reload();
    } catch (e) {
      // Hata durumunda kullanıcıya mesaj göster
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
      // 1. Kullanıcının resim seçmesini sağla
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
        return;
      }

      final File imageFile = File(pickedFile.path);

      // 2. Resmi Firebase Cloud Storage'a yükle
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child(user.uid + '.jpg');

      await storageRef.putFile(imageFile);

      // 3. Yeni resim URL'sini al
      final newPhotoUrl = await storageRef.getDownloadURL();

      // 4. Firestore'daki kullanıcı profil resmini güncelle
      await db
          .collection('users')
          .doc(user.uid)
          .update({'image_url': newPhotoUrl});

      // 5. Kullanıcıya başarı mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile photo: $e')),
      );
    }
  }

  Future<void> _deleteAccount() async {
    // Kullanıcıdan mevcut şifresini al
    String? password = await _promptForPassword(context);
    if (password == null || password.isEmpty) {
      // Kullanıcı şifre girmemişse işlemi iptal et
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password is required to update email')),
      );
      return;
    }

    try {
      // Kullanıcıyı mevcut şifresiyle yeniden kimlik doğrulama
      AuthCredential credential = EmailAuthProvider.credential(
        email: authenticatedUser.email!,
        password: password,
      );

      await authenticatedUser.reauthenticateWithCredential(credential);

      // Firebase Authentication'daki e-posta adresini güncelle
      await authenticatedUser.delete();
      await FirebaseStorage.instance
          .ref()
          .child('user_photos')
          .child('${authenticatedUser.uid}.jpg')
          .delete();
      await db.collection('users').doc(authenticatedUser.uid).delete();

      // Oturumu yenileme
      // await FirebaseAuth.instance.currentUser!.reload();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Hata durumunda kullanıcıya mesaj göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed delete account: $e')),
      );
    }
  }
}
