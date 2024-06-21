import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:privatechat/theme/constants.dart';
import 'package:privatechat/components/new_message.dart';

class ChatScreen extends StatefulWidget {
  final String recipientUserId;
  final String recipientUsername;

  const ChatScreen({
    super.key,
    required this.recipientUserId,
    required this.recipientUsername,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? recipientImageUrl;
  String? chatRoomId;

  @override
  void initState() {
    super.initState();
    _loadRecipientData();
    _createChatRoom();
  }

  void _loadRecipientData() async {
    var recipientUserDoc =
        await _firestore.collection('users').doc(widget.recipientUserId).get();

    if (recipientUserDoc.exists) {
      setState(() {
        recipientImageUrl = recipientUserDoc['image_url'];
      });
    }
  }

  void _createChatRoom() async {
    var userId1 = _auth.currentUser!.uid;
    var userId2 = widget.recipientUserId;
    chatRoomId = getChatRoomId(userId1, userId2);
    createChatRoom(userId1, userId2);
  }

  void createChatRoom(String userId1, String userId2) async {
    var chatRoomId = getChatRoomId(userId1, userId2);
    var chatRoomData = {
      'participants': [userId1, userId2],
    };

    await _firestore.collection('chats').doc(chatRoomId).set(chatRoomData);
  }

  String getChatRoomId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('-');
  }

  void sendMessage(String messageText) async {
    if (chatRoomId != null) {
      var messageData = {
        'text': messageText,
        'senderId': _auth.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Text(
              (widget.recipientUserId == _auth.currentUser!.uid
                  ? 'You'
                  : widget.recipientUsername),
              style: kTitleText,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: chatRoomId != null
                    ? _firestore
                        .collection('chats')
                        .doc(chatRoomId)
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots()
                    : Stream.empty(),
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

                      return ListTile(
                        title: Text(message['text']),
                        subtitle: Text(timeString),
                      );
                    },
                  );
                },
              ),
            ),
            NewMessage(onSendMessage: sendMessage),
          ],
        ),
      ),
    );
  }
}
