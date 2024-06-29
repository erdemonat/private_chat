import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/custom_streams/get_recipient_user_data_builder.dart';
import 'package:privatechat/providers/stream_provider.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final firestoreProvider = Provider.of<FirestoreStreamProviders>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: firestoreProvider.getUserChatsStream(),
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

              return GetRecipientUserDataBuilder(
                  stream:
                      firestoreProvider.getRecipientUserData(recipientUserId),
                  chatRoomId: chatRoomId,
                  recipientUserId: recipientUserId,
                  currentUser: currentUser,
                  chatDoc: chatDoc);
            },
          ),
        );
      },
    );
  }
}
