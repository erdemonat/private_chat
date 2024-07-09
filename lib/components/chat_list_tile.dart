import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:privatechat/theme/theme.dart';

class ChatListTile extends StatelessWidget {
  final String recipientImageUrl;

  final String recipientUsername;

  final String lastMessage;

  final Timestamp lastMessageTimestamp;

  final int newMessageCounter;

  final void Function()? onTap;

  ChatListTile({
    super.key,
    required this.recipientImageUrl,
    required this.recipientUsername,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.newMessageCounter,
    this.onTap,
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
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          child: ClipOval(
            child: recipientImageUrl.isNotEmpty
                ? Image.network(
                    recipientImageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                  )
                : Image.asset(
                    'assets/images/defaultpp.jpg',
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
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatTimestamp(lastMessageTimestamp),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
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
            if (newMessageCounter == 0)
              const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 10,
                child: Text(''),
              )
          ],
        ),
      ),
    );
  }
}
