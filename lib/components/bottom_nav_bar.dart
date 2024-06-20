import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyNavigationBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  const MyNavigationBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        child: GNav(
          onTabChange: (value) => onTabChange!(value),
          curve: Curves.easeInOutExpo,
          tabBorderRadius: 8,
          rippleColor: Theme.of(context).colorScheme.tertiary,
          //hoverColor: const Color.fromARGB(255, 180, 6, 6)!,
          gap: 8,
          activeColor: Theme.of(context).colorScheme.surface,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          mainAxisAlignment: MainAxisAlignment.center,
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: Theme.of(context).colorScheme.secondary,
          color: Theme.of(context).colorScheme.primary,
          tabs: const [
            GButton(
              icon: Icons.chat_bubble_rounded,
              text: 'Chats',
            ),
            GButton(
              icon: Icons.people,
              text: 'Contacts',
            ),
          ],
        ),
      ),
    );
  }
}
