import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:privatechat/custom_streams/get_online_status_builder.dart';
import 'package:privatechat/custom_streams/get_chat_messages_builder.dart';
import 'package:privatechat/providers/stream_provider.dart';
import 'package:privatechat/components/new_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String recipientUserId;
  final String recipientUsername;

  ChatScreen({
    super.key,
    required this.recipientUserId,
    required this.recipientUsername,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? recipientImageUrl;
  String? chatRoomId;

  @override
  void initState() {
    super.initState();
    _loadRecipientData();
    _createChatRoomAndFixStatus();
  }

  void _createChatRoomAndFixStatus() async {
    await _createChatRoom();
    _onlineStatusFix();
  }

  void _onlineStatusFix() async {
    await _db.collection('chats').doc(chatRoomId).update(
      {
        'isOnChat-${widget.recipientUserId}': false,
        'isOnChat-${_auth.currentUser!.uid}': true,
      },
    );
  }

  void _loadRecipientData() async {
    var recipientUserDoc =
        await _db.collection('users').doc(widget.recipientUserId).get();

    if (recipientUserDoc.exists) {
      setState(() {
        recipientImageUrl = recipientUserDoc['image_url'];
      });
    }
  }

  Future<void> _createChatRoom() async {
    var userId1 = _auth.currentUser!.uid;
    var userId2 = widget.recipientUserId;
    chatRoomId = getChatRoomId(userId1, userId2);
    createChatRoom(userId1, userId2);
  }

  Future<void> createChatRoom(String userId1, String userId2) async {
    var chatRoomId = getChatRoomId(userId1, userId2);
    var chatRoomData = {
      'participants': [userId1, userId2],
    };

    await _db
        .collection('chats')
        .doc(chatRoomId)
        .set(chatRoomData, SetOptions(merge: true));
  }

  String getChatRoomId(String userId1, String userId2) {
    if (userId1 == userId2) {
      return '$userId1-ownnotes';
    } else {
      List<String> ids = [userId1, userId2];
      ids.sort();
      return ids.join('-');
    }
  }

  void sendMessage(String messageText) async {
    if (chatRoomId != null && messageText.isNotEmpty) {
      var messageData = {
        'text': messageText,
        'senderId': _auth.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': Provider.of<FirestoreStreamProviders>(context).isOnline
            ? true
            : false,
      };

      await _db
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);

      await _db.collection('chats').doc(chatRoomId).set(
        {
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
          'newMessageCounter-${_auth.currentUser!.uid}':
              FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreProvider = Provider.of<FirestoreStreamProviders>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              _db.collection('chats').doc(chatRoomId).update(
                {
                  'newMessageCounter-${widget.recipientUserId}': 0,
                  'isOnChat-${_auth.currentUser!.uid}': false
                },
              );
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                size: 28,
              ),
            ),
          )
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            CircleAvatar(
              child: recipientImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: recipientImageUrl!,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
            const SizedBox(
              width: 12,
            ),
            Flexible(
              child: GetOnlineStatus(
                stream: firestoreProvider.getChatRoomFields(chatRoomId),
                recipientUserId: widget.recipientUserId,
                recipientUsername: widget.recipientUsername,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          image: DecorationImage(
            image: const AssetImage(
              'assets/images/chat-back-3.png',
            ), // Buraya resim yolunu yazın
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.surface, BlendMode.srcATop),

            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GetChatMessagesBuilder(
                  stream: chatRoomId != null
                      ? firestoreProvider.getChatMessages(chatRoomId)
                      : const Stream.empty(),
                ),
              ),
              NewMessage(onSendMessage: sendMessage),
            ],
          ),
        ),
      ),
    );
  }
}
