import 'package:flutter/material.dart';
import 'package:privatechat/theme/constants.dart';
import 'package:privatechat/components/theme_setting_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> notificationSounds = [
  'assets/sounds/sound1.mp3',
  'assets/sounds/sound2.mp3',
];

void _saveSelectedSound(String soundPath) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('selectedNotificationSound', soundPath);
}

Future<String?> _getSelectedSound() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('selectedNotificationSound');
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _selectedSound;

  @override
  void initState() {
    super.initState();
    _loadSelectedSound();
  }

  void _loadSelectedSound() async {
    String? selectedSound = await _getSelectedSound();
    setState(() {
      _selectedSound = selectedSound ?? notificationSounds[0];
    });
  }

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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25),
            child: Column(
              children: [
                ThemeSettingTile(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notification Sound',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      DropdownButton<String>(
                        value: _selectedSound,
                        items: notificationSounds.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.split('/').last),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSound = newValue;
                          });
                          if (newValue != null) {
                            _saveSelectedSound(newValue);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
