import 'package:flutter/material.dart';

class NoContactsFound extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<InlineSpan>? richTextChildren;

  const NoContactsFound({
    super.key,
    required this.title,
    required this.subtitle,
    this.richTextChildren,
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
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 8,
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: subtitle,
                children: richTextChildren,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
