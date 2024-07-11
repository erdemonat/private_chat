import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:privatechat/components/message_bubble.dart';
import 'package:privatechat/model/chat_messages_data.dart';
import 'package:privatechat/components/new_message.dart';
import 'package:privatechat/theme/constants.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String recipientUserId;
  final String recipientUsername;
  final String recipientImageUrl;
  final String? chatRoomId;

  const ChatScreen({
    super.key,
    required this.recipientUserId,
    required this.recipientUsername,
    required this.recipientImageUrl,
    this.chatRoomId,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? recipientImageUrl;
  String? chatRoomId;
  String currentUser = FirebaseAuth.instance.currentUser!.uid;
  bool isRecipientOnline = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      await _db.collection('chats').doc(chatRoomId).update(
        {
          'isOnChat-$currentUser': false,
        },
      );
    } else if (state == AppLifecycleState.detached) {
      await _db.collection('chats').doc(chatRoomId).update(
        {
          'isOnChat-$currentUser': false,
        },
      );
    } else if (state == AppLifecycleState.resumed) {
      await _db.collection('chats').doc(chatRoomId).update(
        {
          'isOnChat-$currentUser': true,
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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

      _db.collection('chats').doc(chatRoomId).snapshots().listen((chatDoc) {
        if (chatDoc.exists) {
          setState(() {
            isRecipientOnline = chatDoc['isOnChat-${widget.recipientUserId}'];
          });
        }
      });
    }
  }

  Future<void> _createChatRoom() async {
    var userId1 = _auth.currentUser!.uid;
    var userId2 = widget.recipientUserId;
    chatRoomId = getChatRoomId(userId1, userId2);

    var chatRoomDoc = await _db.collection('chats').doc(chatRoomId).get();

    if (!chatRoomDoc.exists) {
      createChatRoom(userId1, userId2);
    }
  }

  Future<void> createChatRoom(String userId1, String userId2) async {
    var chatRoomId = getChatRoomId(userId1, userId2);
    var chatRoomData = {
      'participants': [userId1, userId2],
      'isOnChat-$userId1': true,
      'isOnChat-$userId2': false,
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
        'isRead': isRecipientOnline ? true : false,
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
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        await _db.collection('chats').doc(chatRoomId).update(
          {
            'isOnChat-$currentUser': false,
          },
        );
      },
      child: Scaffold(
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
              ClipOval(
                child: CircleAvatar(
                  child: recipientImageUrl != null
                      ? Image.network(
                          widget.recipientImageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.recipientUserId == currentUser
                        ? 'You'
                        : widget.recipientUsername),
                    style: kAppbarTitle,
                  ),
                  if (isRecipientOnline)
                    const Text(
                      'online',
                      style: TextStyle(fontSize: 14),
                    )
                ],
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
                MultiProvider(
                  providers: [
                    StreamProvider<List<ChatMessage>>.value(
                      value: ChatMessageData().getChatMessages(chatRoomId!),
                      initialData: ChatMessageData.initial(),
                    ),
                  ],
                  child: Consumer<List<ChatMessage>>(
                    builder: (context, messages, child) {
                      return Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            var message = messages[index];
                            var timestamp = message.timestamp;
                            var timeString = '';

                            var dateTime = timestamp.toDate();
                            timeString = DateFormat('HH:mm').format(dateTime);

                            var senderId = message.senderId;
                            bool sentByMe = ChatMessageData()
                                .isMessageFromCurrentUser(
                                    senderId, currentUser);

                            return MessageBubble(
                              sentByMe: sentByMe,
                              message: message.text,
                              timeString: timeString,
                              checkColor:
                                  message.isRead ? Colors.blue : Colors.grey,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                NewMessage(onSendMessage: sendMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
