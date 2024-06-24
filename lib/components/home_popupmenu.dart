import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/model/custom_page_router.dart';
import 'package:privatechat/screens/home.dart';
import 'package:privatechat/screens/profile.dart';
import 'package:privatechat/screens/settings.dart';

class HomePopupButtonMenu extends StatelessWidget {
  const HomePopupButtonMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      enableFeedback: true,
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<SampleItem>>[
          PopupMenuItem<SampleItem>(
            value: SampleItem.settings,
            child: const Text('Profile'),
            onTap: () {
              Navigator.push(
                  context, CustomPageRoute(page: const ProfileScreen()));
            },
          ),
          PopupMenuItem<SampleItem>(
            value: SampleItem.settings,
            child: const Text('Settings'),
            onTap: () {
              Navigator.push(
                  context, CustomPageRoute(page: const SettingsScreen()));
            },
          ),
          PopupMenuItem<SampleItem>(
            value: SampleItem.logout,
            child: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ];
      },
    );
  }
}
