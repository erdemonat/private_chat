import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:privatechat/components/message_bubble.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  Future<QueryDocumentSnapshot<Object?>> getDocument() async {
    // Firestore'dan belirli bir dökümanı al
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('demo')
        .doc('1')
        .collection('messages')
        .doc('2')
        .get();

    return snapshot.get('text');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.surface.withOpacity(0.3),
            BlendMode.srcATop,
          ),
          image: const AssetImage('assets/images/chat-back-3.png'),
        ),
      ),
      child: FutureBuilder<QueryDocumentSnapshot<Object?>>(
        future: getDocument(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ));
          }

          final document = snapshot.data;

          return Center(
            child: Column(
              children: [
                Text(
                  'data',
                  style: TextStyle(color: Colors.red, fontSize: 24),
                ),
                MessageBubble(
                  sentByMe: true,
                  message: document!['text'],
                  timeString: '00:00',
                  checkColor: Colors.blue,
                ),
                MessageBubble(
                  sentByMe: false,
                  message: document['text'],
                  timeString: '00:00',
                  checkColor: Colors.blue,
                ),
                MessageBubble(
                  sentByMe: true,
                  message: document['text'],
                  timeString: '00:00',
                  checkColor: Colors.blue,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
