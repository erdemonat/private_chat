import 'package:flutter/material.dart';

class DeleteAccountButton extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteAccountButton({
    super.key,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TextButton(
        onPressed: onDelete,
        child: Text(
          'Delete account',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
