import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageData {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ChatMessage>> getChatMessages(String chatRoomId) {
    return _db
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                ChatMessage.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList());
  }

  bool isMessageFromCurrentUser(String senderId, String currentUserId) {
    return senderId == currentUserId;
  }

  static List<ChatMessage> initial() {
    return [];
  }
}

class ChatMessage {
  final bool isRead;
  final String senderId;
  final String text;
  final Timestamp timestamp;

  ChatMessage({
    required this.isRead,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromFirestore(Map<String, dynamic> data) {
    return ChatMessage(
      isRead: data['isRead'] as bool,
      senderId: data['senderId'] as String,
      text: data['text'] as String,
      timestamp: data['timestamp'] as Timestamp,
    );
  }
}
