import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privatechat/components/auth_screen_logo.dart';
import 'package:privatechat/model/custom_page_router.dart';
import 'package:privatechat/screens/auth.dart';
import 'package:privatechat/screens/home.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Start the animation
    _controller.repeat(reverse: true);

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1400), () {});
    Navigator.pushReplacement(
      context,
      CustomPageRoute(
          page: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasData) {
                return const HomeScreen();
              }
              return const AuthScreen();
            },
          ),
          transitionType: TransitionType.fade,
          duration: const Duration(milliseconds: 600)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthIcon(),
                  SizedBox(
                    height: 224,
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    'from',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5)),
                  ),
                  Text(
                    'D&O',
                    style: GoogleFonts.lora(
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
