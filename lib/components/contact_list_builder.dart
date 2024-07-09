import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/theme/constants.dart';
import 'package:privatechat/screens/chat.dart';

class ContactList extends StatelessWidget {
  const ContactList({
    super.key,
    required this.filteredUserDocs,
  });

  final List<QueryDocumentSnapshot<Object?>> filteredUserDocs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListView.separated(
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        itemCount: filteredUserDocs.length,
        itemBuilder: (context, index) {
          var user = filteredUserDocs[index];

          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      recipientUserId: user.id,
                      recipientUsername: user['username'],
                      recipientImageUrl: user['image_url'],
                    ),
                  ));
            },
            title: Text(
              user['username'],
              style: kUsernameTextStyle(context),
            ),
            subtitle: Text(
              user['status'],
              style: kSubTextStyle(context),
            ),
            leading: CircleAvatar(
              radius: 24,
              child: ClipOval(
                child: Image.network(
                  width: 48,
                  height: 48,
                  user['image_url'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
