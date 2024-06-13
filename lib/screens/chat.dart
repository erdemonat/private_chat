import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:privatechat/constants.dart';
import 'package:privatechat/util/new_message.dart';

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

  @override
  void initState() {
    super.initState();
    _loadRecipientData();
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
              backgroundImage: recipientImageUrl != null
                  ? NetworkImage(recipientImageUrl!)
                  : null,
              child:
                  recipientImageUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              widget.recipientUsername,
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
                stream: _firestore
                    .collection('chats')
                    .doc(getChatRoomId())
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
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

                      return ListTile(
                        title: Text(message['text']),
                        subtitle: Text(message['sender']),
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

  void sendMessage(String messageText) {
    if (messageText.isNotEmpty) {
      var chatRoomId = getChatRoomId();
      var message = {
        'text': messageText,
        'sender': widget.recipientUsername,
        'timestamp': FieldValue.serverTimestamp(),
      };

      _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(message);
    }
  }

  String getChatRoomId() {
    var currentUser = _auth.currentUser!;
    var otherUser = widget.recipientUserId;

    List<String> ids = [currentUser.uid, otherUser];
    ids.sort();
    return ids.join('-');
  }
}
