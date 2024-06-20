import 'package:flutter/material.dart';
import 'package:privatechat/theme/constants.dart';
import 'package:privatechat/screens/chats.dart';
import 'package:privatechat/screens/contacts.dart';
import 'package:privatechat/components/bottom_nav_bar.dart';
import 'package:privatechat/components/home_popupmenu.dart';

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
    const ContactsScreen(),
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
        actions: const [
          HomePopupButtonMenu(),
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
