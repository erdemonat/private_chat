import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:privatechat/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sentByMe,
    required this.message,
    required this.timeString,
    required this.checkColor,
  });

  final bool sentByMe;
  final String message;
  final String timeString;
  final Color checkColor;

  @override
  Widget build(BuildContext context) {
    bool isGlassBubble =
        Provider.of<ThemeProvider>(context, listen: false).isGlassBubble;

    return isGlassBubble ? glassBubble(context) : defaultBubble(context);
  }

  Row glassBubble(BuildContext context) {
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
                          message,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        const SizedBox(height: 8),
                        !sentByMe
                            ? Text(
                                timeString,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7)),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    timeString,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7)),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.check,
                                    color: checkColor,
                                    size: 18,
                                  )
                                ],
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

  defaultBubble(BuildContext context) {
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
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
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
                color: sentByMe
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                  !sentByMe
                      ? Text(
                          timeString,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7)),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              timeString,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7)),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.check,
                              color: checkColor,
                              size: 18,
                            )
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
