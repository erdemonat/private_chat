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
  final IsarService isarService = IsarService();
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

  // Getter for current theme data
  ThemeData get themeData => _themeData;

  // Getter for selected theme
  AppTheme get selectedTheme => _selectedTheme;

  // Setter for selected theme
  set selectedTheme(AppTheme theme) {
    _selectedTheme = theme;
    _themeData = _themes[theme]!;
    _saveTheme(theme);
    notifyListeners();
  }

  // Load theme from local storage
  Future<void> _loadTheme() async {
    final isar = await isarService.db;
    final themeItem = await isar.themeSettings.where().findFirst();
    if (themeItem != null) {
      _selectedTheme = AppTheme.values
          .firstWhere((e) => e.toString() == 'AppTheme.${themeItem.themeName}');
      _themeData = _themes[_selectedTheme]!;
    }
    notifyListeners();
  }

  // Save theme to local storage
  Future<void> _saveTheme(AppTheme theme) async {
    final isar = await isarService.db;
    await isar.writeTxn(() async {
      await isar.themeSettings.clear(); // Clear old theme
      final themeItem = ThemeSettings()
        ..themeName = theme.toString().split('.').last;
      await isar.themeSettings.put(themeItem);
    });
  }
}
