import 'package:flutter/material.dart';

class NoContactsFound extends StatelessWidget {
  const NoContactsFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: SizedBox(
              height: 150,
              child: Image.asset(
                'assets/images/ghost.png',
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.3),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No contact here',
            style: TextStyle(
              fontSize: 22,
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.3),
            ),
          )
        ],
      ),
    );
  }
}