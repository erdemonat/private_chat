import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Bunu datetime formatlamak için ekliyoruz
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

  Future<Map<String, String>> getRecipientUserData(
      String recipientUserId) async {
    var userDoc = await _db.collection('users').doc(recipientUserId).get();
    if (userDoc.exists) {
      return {
        'username': userDoc['username'],
        'image_url': userDoc['image_url'],
      };
    } else {
      return {
        'username': 'Unknown',
        'image_url': '',
      };
    }
  }

  Future<Map<String, dynamic>> getLastMessage(String chatRoomId) async {
    var lastMessageDoc = await _db
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (lastMessageDoc.docs.isNotEmpty) {
      var lastMessageData = lastMessageDoc.docs.first.data();
      return {
        'text': lastMessageData['text'],
        'timestamp': lastMessageData['timestamp'],
      };
    } else {
      return {
        'text': 'No messages yet',
        'timestamp': null,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        return Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chatDoc = chatDocs[index];
              var chatRoomId = chatDoc.id;
              var participants = chatDoc['participants'] as List<dynamic>;

              var currentUser = _auth.currentUser!;
              var recipientUserId = participants.length == 1
                  ? currentUser.uid
                  : participants.firstWhere(
                      (id) => id != currentUser.uid,
                      orElse: () => currentUser.uid,
                    );

              return FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  getRecipientUserData(recipientUserId),
                  getLastMessage(chatRoomId),
                ]),
                builder: (context, userDataSnapshot) {
                  if (!userDataSnapshot.hasData) {
                    return const ListTile(
                      title: LinearProgressIndicator(),
                    );
                  }

                  var userData =
                      userDataSnapshot.data![0] as Map<String, String>?;
                  var lastMessageData =
                      userDataSnapshot.data![1] as Map<String, dynamic>?;

                  if (userData == null || lastMessageData == null) {
                    return const ListTile(
                      title: Text('Error loading data'),
                    );
                  }

                  var lastMessage = lastMessageData['text'] as String;
                  var lastMessageTimestamp =
                      lastMessageData['timestamp'] as Timestamp?;

                  var username = userData['username']!;
                  var imageUrl = userData['image_url']!;

                  String formatTimestamp(Timestamp? timestamp) {
                    if (timestamp == null) return '';

                    DateTime messageTime = timestamp.toDate();
                    DateTime now = DateTime.now();
                    DateTime todayStart =
                        DateTime(now.year, now.month, now.day);
                    DateTime yesterdayStart =
                        todayStart.subtract(const Duration(days: 1));

                    if (messageTime.isAfter(todayStart)) {
                      return DateFormat('HH:mm')
                          .format(messageTime); // Bugünün saati
                    } else if (messageTime.isAfter(yesterdayStart)) {
                      return 'Yesterday';
                    } else {
                      return DateFormat('dd/MM/yyyy')
                          .format(messageTime); // Daha önceki günler için
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: ListTile(
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(formatTimestamp(lastMessageTimestamp)),
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 24,
                        child: ClipOval(
                          child: Image.network(
                            imageUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                      title: Text(
                        recipientUserId != currentUser.uid ? username : 'You',
                      ),
                      subtitle: Text(
                        lastMessage,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              recipientUserId: recipientUserId,
                              recipientUsername: username,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
