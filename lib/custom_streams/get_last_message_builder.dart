import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:privatechat/model/custom_page_router.dart';
import 'package:privatechat/screens/chat.dart';

class GetLastMessageBuilder extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String chatRoomId;
  final String recipientUserId;
  final String username;
  final String imageUrl;
  final User currentUser;
  final QueryDocumentSnapshot<Object?> chatDoc;

  GetLastMessageBuilder(
      {super.key,
      required this.stream,
      required this.chatRoomId,
      required this.recipientUserId,
      required this.username,
      required this.imageUrl,
      required this.currentUser,
      required this.chatDoc});

  void markMessageAsRead(String chatId, String messageId) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'isRead': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, messageSnapshot) {
        if (messageSnapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: LinearProgressIndicator(),
          );
        }
        if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
          return const ListTile(
            title: Text('No messages yet'),
          );
        }

        var lastMessageDoc = messageSnapshot.data!.docs.first;
        var lastMessageData = lastMessageDoc.data() as Map<String, dynamic>;
        var lastMessage = lastMessageData['text'] as String;
        var lastMessageTimestamp = lastMessageData['timestamp'] as Timestamp?;

        String formatTimestamp(Timestamp? timestamp) {
          if (timestamp == null) return '';

          DateTime messageTime = timestamp.toDate();
          DateTime now = DateTime.now();
          DateTime todayStart = DateTime(now.year, now.month, now.day);
          DateTime yesterdayStart =
              todayStart.subtract(const Duration(days: 1));

          if (messageTime.isAfter(todayStart)) {
            return DateFormat('HH:mm').format(messageTime); // Bugünün saati
          } else if (messageTime.isAfter(yesterdayStart)) {
            return 'Yesterday';
          } else {
            return DateFormat('dd/MM/yyyy')
                .format(messageTime); // Daha önceki günler için
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
                        : Colors.green.withOpacity(0.8),
                  ),
                ),

                /// New message counter
                if (newMessageCounter != 0)
                  CircleAvatar(
                    backgroundColor: Colors.green.withOpacity(0.2),
                    radius: 10,
                    child: Center(
                      child: Text(
                        newMessageCounter.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.tertiary,
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
              recipientUserId != currentUser.uid ? username : 'You',
            ),
            subtitle: Text(
              lastMessage,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
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
  }
}
