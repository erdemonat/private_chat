import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/screens/chat.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Chats cannot be loaded'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No active chats found'),
            );
          }

          var chatDocs = snapshot.data!.docs;
          print("Total chat documents: ${chatDocs.length}");
          chatDocs.forEach((doc) {
            print("Chat Room ID: ${doc.id}");
          });

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chatTile = chatDocs[index];
              var chatRoomId = chatTile.id;

              return ListTile(
                title: Text('Chat Room ID: $chatRoomId'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        recipientUserId: getRecipientUserId(chatRoomId),
                        recipientUsername:
                            'sender', // Replace with actual username if available
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String getRecipientUserId(String chatRoomId) {
    var currentUser = _auth.currentUser!;
    var userIds = chatRoomId.split('-');
    return userIds.firstWhere((id) => id != currentUser.uid);
  }
}
