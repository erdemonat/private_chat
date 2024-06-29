import 'package:flutter/material.dart';

class NoContactsFound extends StatelessWidget {
  const NoContactsFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Center(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: SizedBox(
              height: 250,
              child: Image.asset(
                isLightTheme
                    ? 'assets/images/error-logo-light.png'
                    : 'assets/images/error-logo-dark.png',
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No contact here',
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
          )
        ],
      ),
    );
  }
}
