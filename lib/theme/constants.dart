import 'package:flutter/material.dart';

var kTitleText = const TextStyle(fontSize: 24, fontWeight: FontWeight.w800);

var kButtonStyleAuth = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ));

InputDecoration kTextFormFieldDecoration(BuildContext context) {
  return InputDecoration(
    filled: true,
    fillColor: Theme.of(context).colorScheme.primaryContainer,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  );
}

TextStyle kUsernameTextStyle(BuildContext context) {
  return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.inversePrimary);
}

TextStyle kSubTextStyle(BuildContext context) {
  return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Theme.of(context).colorScheme.inversePrimary);
}
