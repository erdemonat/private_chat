import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color customBlueDark = Color.fromARGB(255, 238, 194, 147);
const Color customBlueLight = Color.fromARGB(255, 145, 10, 17);
const Color customBlueHighContrast = Color(0xFF16FF00);

extension CustomColors on ThemeData {
  Color get customColor {
    if (colorScheme.brightness == Brightness.dark &&
        scaffoldBackgroundColor == Colors.black) {
      return customBlueHighContrast;
    } else if (colorScheme.brightness == Brightness.dark) {
      return customBlueDark;
    } else {
      return customBlueLight;
    }
  }
}

ThemeData darkTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: const Color.fromARGB(255, 18, 25, 33),
  dialogBackgroundColor: const Color.fromARGB(255, 18, 25, 33),
  focusColor: const Color(0xFFF0ECE5),
  dividerColor: const Color(0xFFF0ECE5),
  highlightColor: const Color(0xFFF0ECE5),
  colorScheme: const ColorScheme.dark(
    error: customBlueDark,
    surface: Color.fromARGB(255, 18, 25, 33),
    primary: Color.fromARGB(255, 38, 53, 71),
    secondary: Color.fromARGB(255, 158, 179, 203),
    tertiary: Color(0xFFF0ECE5),
    inversePrimary: Color(0xFFF0ECE5),
    onSurface: Color(0xFFF0ECE5),
    outlineVariant: Color.fromARGB(255, 27, 35, 46),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: const Color(0xFFF0ECE5),
    selectionColor: const Color(0xFF161A30).withOpacity(0.4),
    selectionHandleColor: const Color(0xFFF0ECE5),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF31304D),
    contentTextStyle: TextStyle(
      color: Color(0xFFF0ECE5),
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

ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: Colors.white,
  dialogBackgroundColor: Colors.white,
  focusColor: const Color(0xFF1B1F32),
  dividerColor: const Color(0xFF1B1F32),
  highlightColor: const Color(0xFF1B1F32),
  colorScheme: const ColorScheme.light(
    error: customBlueLight,
    surface: Colors.white,
    primary: Color.fromARGB(255, 199, 209, 218),
    secondary: Color.fromARGB(255, 70, 83, 99),
    tertiary: Color(0xFF1B1F32),
    inversePrimary: Color(0xFF1B1F32),
    onSurface: Color(0xFF1B1F32),
    outlineVariant: Color.fromARGB(255, 237, 242, 247),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: const Color(0xFF1B1F32),
    selectionColor: const Color(0xFF1B1F32).withOpacity(0.4),
    selectionHandleColor: const Color(0xFF1B1F32),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFFF0ECE5),
    contentTextStyle: TextStyle(
      color: Color(0xFF1B1F32),
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

ThemeData highContrastTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: const Color(0xFF000000),
  dialogBackgroundColor: const Color(0xFF000000),
  dividerColor: const Color(0xFFFFFFFF),
  highlightColor: const Color(0xFFFFFFFF),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF000000),
    primary: Color.fromARGB(255, 7, 0, 112),
    secondary: Color(0xFF16FF00),
    tertiary: Color(0xFFFFED00),
    inversePrimary: Colors.white,
    onSurface: Colors.white,
    outlineVariant: Color(0xFFFFED00),
    error: Color(0xFFFF0000),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF16FF00),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: const Color(0xFFFFED00),
    selectionColor: const Color(0xFF000000).withOpacity(0.4),
    selectionHandleColor: const Color(0xFFFFED00),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF16FF00),
    contentTextStyle: TextStyle(
      color: Color(0xFF000000),
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
