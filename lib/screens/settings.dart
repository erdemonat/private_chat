import 'package:flutter/material.dart';
import 'package:privatechat/theme/constants.dart';
import 'package:privatechat/components/theme_setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
        title: Text(
          'Settings',
          style: kAppbarTitle,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 25),
        child: Column(
          children: [
            ThemeSettingTile(),
          ],
        ),
      ),
    );
  }
}
