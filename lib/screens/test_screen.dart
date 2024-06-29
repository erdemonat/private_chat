import 'package:flutter/material.dart';
import 'package:privatechat/model/custom_stream_builder.dart';
import 'package:privatechat/providers/stream_provider.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(child: Consumer<FirestoreStreamProviders>(
              builder: (context, provider, child) {
                return CustomStreamBuilder(
                  stream: provider.getLastChatMessages(
                      'CpHzrRwJS4bVcestlnfzu5V8pyh2-uMLfgeUBYMZoz3wi37zitn6eSKk2'),
                );
              },
            ))
          ],
        ));
  }
}
