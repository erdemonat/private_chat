import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privatechat/firebase_api.dart';
import 'package:privatechat/providers/chat_room_state.dart';
import 'package:privatechat/providers/firestore_service.dart';
import 'package:privatechat/screens/home.dart';
import 'package:privatechat/screens/intro.dart';
import 'package:privatechat/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:privatechat/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  FirebaseFirestore.instance.settings = const Settings(
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    persistenceEnabled: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatRoomState(),
        ),
        StreamProvider<List<DocumentSnapshot>>(
          create: (context) => FirestoreService().getChatsStream(),
          initialData: const [],
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const IntroScreen();
        },
      ),
    );
  }
}
