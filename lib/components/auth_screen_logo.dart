import 'package:flutter/material.dart';
import 'package:privatechat/theme/constants.dart';

class AuthIcon extends StatelessWidget {
  const AuthIcon({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return SafeArea(
      child: Column(
        children: [
          Image.asset(
            isLightTheme
                ? 'assets/images/logo-vector-light.png'
                : 'assets/images/logo-vector-dark.png',
            color: Theme.of(context).colorScheme.tertiary,
            width: 220,
          ),
          Text(
            'TapC',
            style: kTitleText.copyWith(
                color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
