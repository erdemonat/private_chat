import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final fm = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await fm.requestPermission();
    final fcmtoken = await fm.getToken();
    // FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    //   // TODO: If necessary send token to application server.

    //   // Note: This callback is fired at each app startup and whenever a new
    //   // token is generated.
    // }).onError((err) {
    //   // Error getting token.
    // });
    fm.subscribeToTopic('messages');
    print('sektir: $fcmtoken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
