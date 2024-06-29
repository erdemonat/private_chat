import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var _db = FirebaseFirestore.instance;
var _auth = FirebaseAuth.instance;

class FirestoreStreamProviders with ChangeNotifier {
  //
  // Chatroom üstündeki fieldlara erişmek için
  Stream<DocumentSnapshot> getChatRoomFields(chatRoomId) {
    return _db.collection('chats').doc(chatRoomId).snapshots();
  }

  // Chats ekranında konuştuğun kişilerin gösterilmesi için
  Stream<QuerySnapshot> getUserChatsStream() {
    var currentUser = _auth.currentUser!;

    return _db
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots();
  }

  // Chats ekranında son mesajı almamızı sağlıyor
  Stream<QuerySnapshot> getLastChatMessages(String chatRoomId) {
    return _db
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  // Karşıdaki kişinin username ve resmini alıyor
  Stream<Map<String, String>> getRecipientUserData(String recipientUserId) {
    return _db
        .collection('users')
        .doc(recipientUserId)
        .snapshots()
        .map((userDoc) {
      if (userDoc.exists) {
        return {
          'username': userDoc['username'],
          'image_url': userDoc['image_url'],
        };
      } else {
        return {
          'username': 'Unknown',
          'image_url': '',
        };
      }
    });
  }

  // Chat ekranında mesajları almamızı sağlıyor
  Stream<QuerySnapshot> getChatMessages(chatRoomId) {
    return _db
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
