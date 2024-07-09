import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<DocumentSnapshot>> getChatsStream() {
    return _db
        .collection('chats')
        .where("participants", arrayContains: currentUser)
        .orderBy("lastMessageTimestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String chatRoomId) {
    return _db
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }
}
