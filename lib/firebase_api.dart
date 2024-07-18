import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final fm = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // await fm.requestPermission();
    final fcmtoken = await fm.getToken();
    fm.subscribeToTopic('messages');
    print('sektir: $fcmtoken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
