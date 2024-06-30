import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/theme/constants.dart';

class GetOnlineStatus extends StatelessWidget {
  final Stream stream;
  final String recipientUserId;
  final String recipientUsername;

  const GetOnlineStatus(
      {super.key,
      required this.stream,
      required this.recipientUserId,
      required this.recipientUsername});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            '',
            style: kAppbarTitle,
          );
        }
        var statusDoc = snapshot.data!;
        bool isOnline = statusDoc['isOnChat-$recipientUserId'] ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (recipientUserId == _auth.currentUser!.uid
                  ? 'You'
                  : recipientUsername),
              style: kAppbarTitle,
            ),
            if (isOnline)
              const Text(
                'online',
                style: TextStyle(fontSize: 14),
              )
          ],
        );
      },
    );
  }
}
