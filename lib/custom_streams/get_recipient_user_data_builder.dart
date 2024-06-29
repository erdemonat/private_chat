import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/custom_streams/get_last_message_builder.dart';
import 'package:privatechat/providers/stream_provider.dart';
import 'package:provider/provider.dart';

class GetRecipientUserDataBuilder extends StatelessWidget {
  final Stream<Map<String, String>> stream;

  final String chatRoomId;
  final String recipientUserId;

  final User currentUser;
  final QueryDocumentSnapshot<Object?> chatDoc;

  const GetRecipientUserDataBuilder({
    super.key,
    required this.stream,
    required this.chatRoomId,
    required this.recipientUserId,
    required this.currentUser,
    required this.chatDoc,
  });

  @override
  Widget build(BuildContext context) {
    final firestoreProvider = Provider.of<FirestoreStreamProviders>(context);
    return StreamBuilder<Map<String, String>>(
      stream: stream,
      builder: (context, userDataSnapshot) {
        if (!userDataSnapshot.hasData) {
          return const ListTile(
            title: LinearProgressIndicator(),
          );
        }

        var userData = userDataSnapshot.data!;
        var username = userData['username']!;
        var imageUrl = userData['image_url']!;

        return GetLastMessageBuilder(
          stream: firestoreProvider.getLastChatMessages(chatRoomId),
          chatRoomId: chatRoomId,
          recipientUserId: recipientUserId,
          username: username,
          imageUrl: imageUrl,
          currentUser: currentUser,
          chatDoc: chatDoc,
        );
      },
    );
  }
}
