import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineStatusData {
  final bool isOnline;

  OnlineStatusData({
    required this.isOnline,
  });

  factory OnlineStatusData.fromSnapshot(
      DocumentSnapshot snapshot, String recipientUserId) {
    if (!snapshot.exists || snapshot.data() == null) {
      // Eğer sonuç boş ise varsayılan bir OnlineStatusData döndür
      return OnlineStatusData(isOnline: false);
    }
    var data = snapshot.data() as Map<String, dynamic>;
    return OnlineStatusData(
      isOnline: data['isOnChat-$recipientUserId'] as bool? ?? false,
    );
  }

  static OnlineStatusData initial() {
    return OnlineStatusData(isOnline: false);
  }
}
