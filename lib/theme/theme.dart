import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData blackTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: Colors.grey.shade900,
  dialogBackgroundColor: Colors.grey.shade900,
  focusColor: Colors.grey.shade300,
  dividerColor: Colors.grey.shade300,
  highlightColor: Colors.grey.shade300,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade500,
    tertiary: Colors.grey.shade300,
    inversePrimary: Colors.grey.shade300,
    onSurface: Colors.grey.shade300,
    outlineVariant: Colors.grey.shade700,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.grey.shade300,
    selectionColor: Colors.grey.shade900.withOpacity(0.4),
    selectionHandleColor: Colors.grey.shade300,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey.shade800,
    contentTextStyle: TextStyle(
      color: Colors.grey.shade300,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    ),
  ),
);

// light mode
ThemeData whiteTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: Colors.grey.shade200,
  dialogBackgroundColor: Colors.grey.shade300,
  focusColor: Colors.grey.shade900,
  dividerColor: Colors.grey.shade900,
  highlightColor: Colors.grey.shade900,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade200,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade900,
    inversePrimary: Colors.grey.shade900,
    onSurface: Colors.grey.shade900,
    outlineVariant: Colors.grey.shade800,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.grey.shade900,
    selectionColor: Colors.grey.shade200.withOpacity(0.4),
    selectionHandleColor: Colors.grey.shade900,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey.shade500,
    contentTextStyle: TextStyle(
      color: Colors.grey.shade900,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    ),
  ),
);

ThemeData highContrastTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: Colors.black,
  dialogBackgroundColor: Colors.black,
  dividerColor: Colors.black,
  highlightColor: Colors.black,
  colorScheme: const ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.blue,
    secondary: Colors.amber,
    tertiary: Colors.red,
    inversePrimary: Colors.white,
    onSurface: Colors.white,
    outlineVariant: Colors.yellow,
    error: Colors.amber,
  ),
  iconTheme: const IconThemeData(
    color: Colors.amber,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.red,
    selectionColor: Colors.black45,
    selectionHandleColor: Colors.red,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.amber,
    contentTextStyle: TextStyle(
      color: Colors.red,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    ),
  ),
);
