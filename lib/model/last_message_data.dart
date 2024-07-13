import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageData {
  final String messageText;
  final Timestamp timestamp;

  LastMessageData({required this.messageText, required this.timestamp});

  factory LastMessageData.fromSnapshot(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) {
      return LastMessageData(
        messageText: "No messages yet",
        timestamp: Timestamp.now(),
      );
    }
    var doc = snapshot.docs.first.data() as Map<String, dynamic>;
    return LastMessageData(
      messageText: doc['text'] as String? ?? "",
      timestamp: doc['timestamp'] as Timestamp? ?? Timestamp.now(),
    );
  }

  static LastMessageData initial() {
    return LastMessageData(
      messageText: "",
      timestamp: Timestamp.now(),
    );
  }
}
