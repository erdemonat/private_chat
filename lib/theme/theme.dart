// dark mode
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
);

ThemeData highContrastTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: Colors.black,
  dialogBackgroundColor: Colors.black,
  dividerColor: Colors.black,
  highlightColor: Colors.black,
  colorScheme: const ColorScheme.light(
    surface: Colors.black,
    primary: Colors.amber,
    secondary: Colors.blue,
    tertiary: Colors.red,
    inversePrimary: Colors.white,
    onSurface: Colors.white,
    outlineVariant: Colors.yellow,
  ),
  iconTheme: const IconThemeData(
    color: Colors.amber,
  ),
);
