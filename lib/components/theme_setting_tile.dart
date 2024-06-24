import 'package:flutter/material.dart';
import 'package:privatechat/components/my_dropdown_menu.dart';

class ThemeSettingTile extends StatelessWidget {
  const ThemeSettingTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 10, right: 25, left: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primary),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Theme',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            const MyPopupMenuButton(),
          ],
        ),
      ),
    );
  }
}
