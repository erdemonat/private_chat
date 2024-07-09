import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:privatechat/firestore_service.dart';
import 'package:privatechat/theme/theme.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  var currentUser = FirebaseAuth.instance.currentUser;
  ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
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
    var chatDocs = Provider.of<List<DocumentSnapshot>>(context);

//Listview  top padding !!
    return ListView.builder(
      itemCount: chatDocs.length,
      itemBuilder: (context, index) {
        var chatDoc = chatDocs[index];
        var participants = chatDoc["participants"];
        var recipientUserId = participants.length == 1
            ? FirestoreService().currentUser
            : participants.firstWhere(
                (id) => id != FirestoreService().currentUser,
                orElse: () => FirestoreService().currentUser,
              );
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(recipientUserId)
              .snapshots()
              .map(
            (userDoc) {
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
            },
          ),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            var userDoc = snapshot.data!;
            var recipentUsername = userDoc["username"];
            var recipentImageUrl = userDoc["image_url"];
            return ChatListTile(
              recipientUsername: recipentUsername,
              recipientImageUrl: recipentImageUrl,
              lastMessage: 'lastChatMessage',
              lastMessageTimestamp: chatDoc["lastMessageTimestamp"],
              newMessageCounter: chatDoc["newMessageCounter-$recipientUserId"],
            );
          },
        );
      },
    );
  }
}

class ChatListTile extends StatelessWidget {
  final String recipientImageUrl;

  final String recipientUsername;

  final String lastMessage;

  final Timestamp lastMessageTimestamp;

  final int newMessageCounter;

  ChatListTile({
    super.key,
    required this.recipientImageUrl,
    required this.recipientUsername,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.newMessageCounter,
  });

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';

    DateTime messageTime = timestamp.toDate();
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime yesterdayStart = todayStart.subtract(const Duration(days: 1));

    if (messageTime.isAfter(todayStart)) {
      return DateFormat('HH:mm').format(messageTime);
    } else if (messageTime.isAfter(yesterdayStart)) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(messageTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ListTile(
        onTap: () {
          //Chat Navigation Function
          //MarkasRead();
          //NewMessageCounter(recipientuser.uid);
          //isOnChat-current.user;
        },
        leading: CircleAvatar(
          radius: 24,
          child: ClipOval(
            child: Image.network(
              recipientImageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        title: Text(
          recipientUsername,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        subtitle: Text(
          lastMessage,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatTimestamp(lastMessageTimestamp)),
            if (newMessageCounter != 0)
              CircleAvatar(
                backgroundColor: Theme.of(context).customColor,
                radius: 10,
                child: Text(
                  newMessageCounter.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
