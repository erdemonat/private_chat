import 'package:flutter/material.dart';
import 'package:privatechat/theme/theme.dart';

enum AppTheme {
  black,
  white,
  contrast,
}

class ThemeProvider with ChangeNotifier {
  // initially, theme is light mode
  ThemeData _themeData = blackTheme;
  final Map<AppTheme, ThemeData> _themes = {
    AppTheme.black: blackTheme,
    AppTheme.white: whiteTheme,
    AppTheme.contrast: highContrastTheme,
  };

  AppTheme _selectedTheme = AppTheme.black;

  // getter method to access the theme from other parts of the code
  ThemeData get themeData => _themeData;

  // setter method to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  AppTheme get selectedTheme => _selectedTheme;

  set selectedTheme(AppTheme theme) {
    _selectedTheme = theme;
    _themeData = _themes[theme]!;
    notifyListeners();
  }

  void setTheme(AppTheme theme) {
    selectedTheme = theme;
  }
}
