import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/components/chat_list_tile.dart';
import 'package:privatechat/firestore_service.dart';
import 'package:privatechat/model/custom_page_router.dart';
import 'package:privatechat/model/last_message_data.dart';
import 'package:privatechat/model/user_data.dart';
import 'package:privatechat/screens/chat.dart';
import 'package:provider/provider.dart';

String currentUser = FirestoreService().currentUser;

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  void updateOnlineStatusMessageCounter(String docId, String recipientUserId) {
    FirebaseFirestore.instance.collection('chats').doc(docId).update({
      'newMessageCounter-$recipientUserId': 0,
      'isOnChat-$currentUser': true
    });
  }

  void markMessageAsRead(String chatId, String id) async {
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

        if (messageData['senderId'] != currentUser && !messageData['isRead']) {
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
        var chatRoomId = chatDoc.id;
        var participants = chatDoc["participants"];
        var recipientUserId = participants.length == 1
            ? currentUser
            : participants.firstWhere(
                (id) => id != currentUser,
                orElse: () => currentUser,
              );
        return MultiProvider(
          providers: [
            StreamProvider<UserData>.value(
              value: FirestoreService().getUserStream(recipientUserId),
              initialData: UserData.initial(),
            ),
            StreamProvider<LastMessageData>.value(
              value: FirestoreService().getLastMessage(chatRoomId).map(
                    (snapshot) => LastMessageData.fromSnapshot(snapshot),
                  ),
              initialData: LastMessageData
                  .initial(), // Bu metodun tanımlanması gerekiyor
            ),
          ],
          child: Consumer2<UserData, LastMessageData>(
            builder: (context, userData, messageData, child) {
              return ChatListTile(
                recipientUsername: userData.username,
                recipientImageUrl: userData.imageUrl,
                lastMessage: messageData.messageText,
                lastMessageTimestamp: messageData.timestamp,
                newMessageCounter:
                    chatDoc["newMessageCounter-$recipientUserId"],
                onTap: () {
                  Navigator.of(context).push(
                    CustomPageRoute(
                      page: ChatScreen(
                          recipientUserId: recipientUserId,
                          recipientUsername: userData.username),
                    ),
                  );
                  updateOnlineStatusMessageCounter(chatDoc.id, recipientUserId);
                  markMessageAsRead(chatDoc.id, messageData.messageText);
                },
              );
            },
          ),
        );
      },
    );
  }
}
