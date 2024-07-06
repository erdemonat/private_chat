import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/theme/theme.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

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
//Listview  top padding !!
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
            child: Image.asset(
              'assets/images/defaultpp.jpg',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        title: Text(
          'Username',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        subtitle: Text(
          'last message',
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('00:00'),
            CircleAvatar(
              backgroundColor: Theme.of(context).customColor,
              radius: 10,
              child: Text(
                '1',
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
