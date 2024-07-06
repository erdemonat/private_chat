import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onUpdatePhoto;

  const ProfileAvatar({
    required this.imageUrl,
    required this.onUpdatePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 79,
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 158,
              height: 158,
            ),
          ),
        ),
        CircleAvatar(
          child: IconButton(
            onPressed: onUpdatePhoto,
            icon: const Icon(Icons.camera_alt_outlined, size: 25),
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        )
      ],
    );
  }
}
