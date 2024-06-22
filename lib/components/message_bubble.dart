import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sentByMe,
    required this.message,
    required this.timeString,
  });

  final bool sentByMe;
  final QueryDocumentSnapshot<Object?> message;
  final String timeString;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: sentByMe
                  ? const Radius.circular(15)
                  : const Radius.circular(0),
              topRight: sentByMe
                  ? const Radius.circular(0)
                  : const Radius.circular(15),
              bottomLeft: const Radius.circular(15),
              bottomRight: const Radius.circular(15),
            ),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2,
                    sigmaY: 2,
                  ),
                ),
                Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.2)),
                      borderRadius: BorderRadius.only(
                        topLeft: sentByMe
                            ? const Radius.circular(15)
                            : const Radius.circular(0),
                        topRight: sentByMe
                            ? const Radius.circular(0)
                            : const Radius.circular(15),
                        bottomLeft: const Radius.circular(15),
                        bottomRight: const Radius.circular(15),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.4),
                          Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.1),
                        ],
                      ),
                      // color: sentByMe
                      //     ? Theme.of(context).colorScheme.primary.withOpacity(0.6)
                      //     : Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message['text'],
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          timeString,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiary
                                  .withOpacity(0.7)),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
