import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String username;
  final String imageUrl;

  UserData({required this.username, required this.imageUrl});

  // Firestore'dan gelen bir Snapshot'ı UserData nesnesine dönüştüren bir factory constructor
  factory UserData.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserData(
      username: data['username'] ?? '',
      imageUrl: data['image_url'] ?? '',
    );
  }

  // Başlangıç değerleri olan bir UserData nesnesi oluşturmak için kullanılır.
  static UserData initial() {
    return UserData(username: '', imageUrl: '');
  }
}
