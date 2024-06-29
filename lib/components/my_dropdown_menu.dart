import 'package:flutter/material.dart';
import 'package:privatechat/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyPopupMenuButton extends StatelessWidget {
  const MyPopupMenuButton({super.key});

  // Fonksiyon: Temanın ismini formatlar (ilk harf büyük)
  String formatThemeName(AppTheme theme) {
    String name = theme.toString().split('.').last;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = context.watch<ThemeProvider>().selectedTheme;

    return PopupMenuButton<AppTheme>(
      elevation: 0,
      offset: const Offset(19, -2),
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) {
        return AppTheme.values
            .where((AppTheme theme) => theme != selectedTheme)
            .map((AppTheme theme) {
          return PopupMenuItem<AppTheme>(
            value: theme,
            child: SizedBox(
              width: 85,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      formatThemeName(theme),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
      onSelected: (AppTheme theme) {
        context.read<ThemeProvider>().selectedTheme = theme;
      },
      tooltip: 'Select Theme',
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextButton.icon(
          onPressed:
              null, // Bu, tıklanabilirliği PopupMenuButton tarafından kontrol edilir
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          label: Text(
            formatThemeName(selectedTheme),
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
