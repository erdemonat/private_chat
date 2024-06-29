import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:privatechat/components/message_bubble.dart';

class GetChatMessagesBuilder extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> stream;

  bool isMe(String senderId) {
    return _auth.currentUser != null && senderId == _auth.currentUser!.uid;
  }

  GetChatMessagesBuilder({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var messages = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var message = messages[index];
            var timestamp = message['timestamp'];
            var timeString = '';

            if (timestamp != null) {
              var dateTime = timestamp.toDate();
              timeString = DateFormat('HH:mm').format(dateTime);
            }

            var senderId = message['senderId'];
            bool sentByMe = isMe(senderId);

            return MessageBubble(
              sentByMe: sentByMe,
              message: message,
              timeString: timeString,
              checkColor: message['isRead'] ? Colors.blue : Colors.grey,
            );
          },
        );
      },
    );
  }
}
