import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color customBlueDark = Color(0xFFF6B17A);
const Color customBlueLight = Color(0xFF910A67);
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

ThemeData blackTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: const Color(0xFF161A30),
  dialogBackgroundColor: const Color(0xFF161A30),
  focusColor: const Color(0xFFF0ECE5),
  dividerColor: const Color(0xFFF0ECE5),
  highlightColor: const Color(0xFFF0ECE5),
  colorScheme: const ColorScheme.dark(
    error: customBlueDark,
    surface: Color(0xFF161A30),
    primary: Color(0xFF31304D),
    secondary: Color(0xFFB6BBC4),
    tertiary: Color(0xFFF0ECE5),
    inversePrimary: Color.fromARGB(255, 214, 219, 226),
    onSurface: Color(0xFFF0ECE5),
    outlineVariant: Color(0xFF31304D),
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

// light mode

ThemeData whiteTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: const Color(0xFFFDF7E4),
  dialogBackgroundColor: const Color(0xFFFAEED1),
  focusColor: const Color(0xFFBBAB8C),
  dividerColor: const Color(0xFFBBAB8C),
  highlightColor: const Color(0xFFBBAB8C),
  colorScheme: const ColorScheme.light(
    error: customBlueLight,
    surface: Color(0xFFFDF7E4),
    primary: Color(0xFFDED0B6),
    secondary: Color(0xFFBBAB8C),
    tertiary: Color(0xFF3E3232),
    inversePrimary: Color.fromARGB(255, 94, 74, 74),
    onSurface: Color(0xFF3E3232),
    outlineVariant: Color(0xFFDED0B6),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: const Color(0xFFBBAB8C),
    selectionColor: const Color(0xFFFDF7E4).withOpacity(0.4),
    selectionHandleColor: const Color(0xFFBBAB8C),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFFDED0B6),
    contentTextStyle: TextStyle(
      color: Color(0xFFBBAB8C),
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
  scaffoldBackgroundColor: const Color(0xFF000000), // #000000
  dialogBackgroundColor: const Color(0xFF000000), // #000000
  dividerColor: const Color(0xFFFFFFFF), // White for high contrast
  highlightColor: const Color(0xFFFFFFFF), // White for high contrast
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF000000), // #000000
    primary: Color.fromARGB(255, 7, 0, 112), // #0F6292
    secondary: Color(0xFF16FF00), // #16FF00
    tertiary: Color(0xFFFFED00), // #FFED00
    inversePrimary: Colors.white,
    onSurface: Colors.white,
    outlineVariant: Color(0xFFFFED00), // #FFED00
    error: Color(0xFFFF0000), // Bright red for high contrast
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF16FF00), // #16FF00
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: const Color(0xFFFFED00), // #FFED00
    selectionColor: const Color(0xFF000000)
        .withOpacity(0.4), // #000000 with opacity for better visibility
    selectionHandleColor: const Color(0xFFFFED00), // #FFED00
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF16FF00), // #16FF00
    contentTextStyle: TextStyle(
      color: Color(0xFF000000), // #000000 for high contrast
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
