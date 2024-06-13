import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/constants.dart';
import 'package:privatechat/model/my_list_tile_model.dart';
import 'package:privatechat/util/my_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var db = FirebaseFirestore.instance;

  final authenticatedUser = FirebaseAuth.instance.currentUser!;

  // final docRef = db.collection("users").doc(user.uid);
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

          final _userEmail = snapshot.data!.data()!['email'];
          final _username = snapshot.data!.data()!['username'];
          final _userImage = snapshot.data!.data()!['image_url'];

          return SingleChildScrollView(
            child: Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 32),
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
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        child: Column(
                          children: [
                            EditableListTile(
                                model: ListModel(
                                    title: 'Username', subTitle: _username)),
                            EditableListTile(
                                model: ListModel(
                                    title: 'Email', subTitle: _userEmail)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Delete',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: ' an account',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print('Tap Here onTap')),
                      ],
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
}
