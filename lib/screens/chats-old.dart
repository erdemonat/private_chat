import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:privatechat/model/custom_page_router.dart';
import 'package:privatechat/screens/chat.dart';
import 'package:privatechat/theme/theme.dart';

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
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatMessagesStream(String chatRoomId) {
    return _db
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<Map<String, String>> getRecipientUserData(String recipientUserId) {
    return _db
        .collection('users')
        .doc(recipientUserId)
        .snapshots()
        .map((userDoc) {
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
    });
  }

  void markMessageAsRead(String chatId, String id) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      for (DocumentSnapshot messageSnapshot in messagesSnapshot.docs) {
        Map<String, dynamic> messageData =
            messageSnapshot.data() as Map<String, dynamic>;

        if (messageData['senderId'] != currentUser.uid &&
            !messageData['isRead']) {
          await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .doc(messageSnapshot.id)
              .update({'isRead': true});
        }
      }
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Find the username in Contacts to chat',
                softWrap: true,
                maxLines: 2,
                style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
                    fontSize: 16),
              ),
            ),
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

              return StreamBuilder<Map<String, String>>(
                stream: getRecipientUserData(recipientUserId),
                builder: (context, userDataSnapshot) {
                  if (!userDataSnapshot.hasData) {
                    return const ListTile(
                      title: LinearProgressIndicator(),
                    );
                  }

                  var userData = userDataSnapshot.data!;
                  var username = userData['username']!;
                  var imageUrl = userData['image_url']!;

                  return StreamBuilder<QuerySnapshot>(
                    stream: getChatMessagesStream(chatRoomId),
                    builder: (context, messageSnapshot) {
                      if (messageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const ListTile(
                          title: LinearProgressIndicator(),
                        );
                      }
                      if (!messageSnapshot.hasData ||
                          messageSnapshot.data!.docs.isEmpty) {
                        return const ListTile(
                          title: Text('No messages yet'),
                        );
                      }

                      var lastMessageDoc = messageSnapshot.data!.docs.first;
                      var lastMessageData =
                          lastMessageDoc.data() as Map<String, dynamic>;
                      var lastMessage = lastMessageData['text'] as String;
                      var lastMessageTimestamp =
                          lastMessageData['timestamp'] as Timestamp?;

                      String formatTimestamp(Timestamp? timestamp) {
                        if (timestamp == null) return '';

                        DateTime messageTime = timestamp.toDate();
                        DateTime now = DateTime.now();
                        DateTime todayStart =
                            DateTime(now.year, now.month, now.day);
                        DateTime yesterdayStart =
                            todayStart.subtract(const Duration(days: 1));

                        if (messageTime.isAfter(todayStart)) {
                          return DateFormat('HH:mm').format(messageTime);
                        } else if (messageTime.isAfter(yesterdayStart)) {
                          return 'Yesterday';
                        } else {
                          return DateFormat('dd/MM/yyyy').format(messageTime);
                        }
                      }

                      int newMessageCounter =
                          chatDoc['newMessageCounter-$recipientUserId'] ?? 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ListTile(
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                formatTimestamp(lastMessageTimestamp),
                                style: TextStyle(
                                  color: newMessageCounter == 0
                                      ? Theme.of(context)
                                          .colorScheme
                                          .tertiary
                                          .withOpacity(0.6)
                                      : Theme.of(context).customColor,
                                ),
                              ),

                              /// New message counter
                              if (newMessageCounter != 0)
                                ClipOval(
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).customColor,
                                    radius: 10,
                                    child: Center(
                                      child: Text(
                                        newMessageCounter.toString(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (newMessageCounter == 0)
                                const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.transparent,
                                ),
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
                            recipientUserId != currentUser.uid
                                ? username
                                : 'You',
                          ),
                          subtitle: Text(
                            lastMessage,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiary
                                  .withOpacity(0.6),
                            ),
                          ),
                          onTap: () {
                            markMessageAsRead(chatRoomId, lastMessageDoc.id);
                            _db.collection('chats').doc(chatRoomId).update({
                              'newMessageCounter-$recipientUserId': 0,
                              'isOnChat-${_auth.currentUser!.uid}': true
                            });
                            Navigator.of(context).push(
                              CustomPageRoute(
                                page: ChatScreen(
                                  recipientUserId: recipientUserId,
                                  recipientUsername: username,
                                ),
                                transitionType: TransitionType.slideFromLeft,
                              ),
                            );
                          },
                        ),
                      );
                    },
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
