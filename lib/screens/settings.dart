import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:privatechat/theme/constants.dart';
import 'package:privatechat/components/theme_setting_tile.dart';
import 'package:privatechat/theme/theme_provider.dart';
import 'package:provider/provider.dart';

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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25),
            child: Column(
              children: [
                ThemeSettingTile(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.5, horizontal: 12),
                  margin:
                      const EdgeInsets.only(bottom: 10, right: 25, left: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primary),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Glass Bubbles',
                          style: kSettingsTextStyle(context),
                        ),
                        CupertinoSwitch(
                          thumbColor:
                              Theme.of(context).colorScheme.inversePrimary,
                          trackColor: Theme.of(context).colorScheme.surface,
                          activeColor: Theme.of(context).colorScheme.secondary,
                          value:
                              Provider.of<ThemeProvider>(context).isGlassBubble,
                          onChanged: (value) {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleBubble();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(height: 12),
                // Container(
                //   height: 560,
                //   width: 300,
                //   decoration: BoxDecoration(
                //       color: Theme.of(context).colorScheme.primary),
                //   child: Demo(),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
