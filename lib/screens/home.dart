import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privatechat/components/bottom_nav_bar.dart';
import 'package:privatechat/components/home_popupmenu.dart';
import 'package:privatechat/screens/chats.dart';
import 'package:privatechat/screens/contacts.dart';

enum SampleItem { settings, logout }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const ChatsScreen(),
    const ContactsScreen(),
  ];

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
            'TapC',
            style:
                GoogleFonts.cinzel(fontWeight: FontWeight.w600, fontSize: 24),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: MyNavigationBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
    );
  }
}
