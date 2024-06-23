import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kTitleText = GoogleFonts.cinzel(
  fontSize: 46,
  fontWeight: FontWeight.bold,
);

var kAppbarTitle = const TextStyle(fontWeight: FontWeight.w600, fontSize: 24);

var kButtonStyleAuth = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ));

InputDecoration kTextFormFieldDecoration(BuildContext context) {
  return InputDecoration(
    floatingLabelStyle:
        TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
    filled: true,
    fillColor: Theme.of(context).colorScheme.primaryContainer,
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
    ),
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
