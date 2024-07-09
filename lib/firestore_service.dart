import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:privatechat/model/user_data.dart';

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

  Stream<UserData> getUserStream(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      return UserData.fromSnapshot(snapshot);
    });
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
