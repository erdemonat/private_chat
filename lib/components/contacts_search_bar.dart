import 'package:flutter/material.dart';

class ContactScreenSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onChanged;

  const ContactScreenSearchBar({
    super.key,
    required this.searchController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
      child: TextField(
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search contacts',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
