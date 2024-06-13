import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/constants.dart';
import 'package:privatechat/screens/chats.dart';
import 'package:privatechat/screens/contacts.dart';
import 'package:privatechat/screens/profile.dart';
import 'package:privatechat/screens/settings.dart';
import 'package:privatechat/util/bottom_nav_bar.dart';

enum SampleItem { settings, logout }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    ChatsScreen(),
    ContactsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          PopupMenuButton(
            enableFeedback: true,
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<SampleItem>>[
                PopupMenuItem<SampleItem>(
                  value: SampleItem.settings,
                  child: const Text('Profile'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ));
                  },
                ),
                PopupMenuItem<SampleItem>(
                  value: SampleItem.settings,
                  child: const Text('Settings'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ));
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
          )
        ],
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            'Private Chat',
            style: kTitleText,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: MyNavigationBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
    );
  }
}
