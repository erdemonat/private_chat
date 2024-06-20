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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: PopupMenuButton<AppTheme>(
        itemBuilder: (BuildContext context) {
          return AppTheme.values.map((AppTheme theme) {
            bool isSelected = selectedTheme == theme;
            return PopupMenuItem<AppTheme>(
              value: theme,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatThemeName(theme),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.inversePrimary
                                  : Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.inversePrimary,
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
