import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:privatechat/local_data/isar_service.dart';
import 'package:privatechat/local_data/theme_settings.dart';
import 'package:privatechat/theme/theme.dart';

enum AppTheme {
  black,
  white,
  contrast,
}

class ThemeProvider with ChangeNotifier {
  final IsarService _isarService = IsarService();
  // initially, theme is light mode
  ThemeData _themeData = blackTheme;
  final Map<AppTheme, ThemeData> _themes = {
    AppTheme.black: blackTheme,
    AppTheme.white: whiteTheme,
    AppTheme.contrast: highContrastTheme,
  };

  ThemeProvider() {
    _loadTheme();
  }

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
    _saveTheme(theme);
    notifyListeners();
  }

  void setTheme(AppTheme theme) {
    selectedTheme = theme;
  }

  Future<void> _loadTheme() async {
    final isar = await _isarService.db;
    final themeItem = await isar.themeSettings.where().findFirst();
    if (themeItem != null) {
      _selectedTheme = AppTheme.values
          .firstWhere((e) => e.toString() == 'AppTheme.${themeItem.themeName}');
      _themeData = _themes[_selectedTheme]!;
    }
    notifyListeners();
  }

  Future<void> _saveTheme(AppTheme theme) async {
    final isar = await _isarService.db;
    await isar.writeTxn(() async {
      await isar.themeSettings.clear(); // Eski temayı temizle
      final themeItem = ThemeSettings()
        ..themeName = theme.toString().split('.').last;
      await isar.themeSettings.put(themeItem);
    });
  }
}
