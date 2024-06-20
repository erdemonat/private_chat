import 'package:flutter/material.dart';
import 'package:privatechat/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDropdownButtonMenu extends StatelessWidget {
  const MyDropdownButtonMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AppTheme>(
      elevation: 0,
      icon: const Icon(Icons.arrow_drop_down_rounded),
      iconSize: 36,
      alignment: Alignment.center,
      underline: const SizedBox(),
      dropdownColor: Theme.of(context).colorScheme.secondary,
      iconEnabledColor: Theme.of(context).colorScheme.tertiary,
      style: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      value: context.watch<ThemeProvider>().selectedTheme,
      onChanged: (value) {
        if (value != null) {
          context.read<ThemeProvider>().setTheme(value);
        }
      },
      items: AppTheme.values.map((AppTheme theme) {
        return DropdownMenuItem<AppTheme>(
          value: theme,
          child: Text(theme.toString().split('.').last),
        );
      }).toList(),
    );
  }
}
