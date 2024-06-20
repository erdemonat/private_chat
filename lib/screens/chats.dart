import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/screens/chat.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getUserChatsStream() {
    var currentUser = _auth.currentUser!;
    return _db
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .snapshots();
  }

  Future<String> getRecipientUsername(String recipientUserId) async {
    var userDoc = await _db.collection('users').doc(recipientUserId).get();
    return userDoc.exists ? userDoc['username'] : 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserChatsStream(),
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

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chatDoc = chatDocs[index];
              var chatRoomId = chatDoc.id;
              var participants = chatDoc['participants'] as List<dynamic>;

              var currentUser = _auth.currentUser!;
              var recipientUserId =
                  participants.firstWhere((id) => id != currentUser.uid);

              return FutureBuilder<String>(
                future: getRecipientUsername(recipientUserId),
                builder: (context, usernameSnapshot) {
                  if (!usernameSnapshot.hasData) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  return ListTile(
                    title: Text(usernameSnapshot.data!),
                    subtitle: Text('Chat Room ID: $chatRoomId'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            recipientUserId: recipientUserId,
                            recipientUsername: usernameSnapshot.data!,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
