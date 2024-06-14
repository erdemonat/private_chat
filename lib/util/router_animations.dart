import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

Route createFadeThroughRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        fillColor: Colors.white,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 800),
  );
}
