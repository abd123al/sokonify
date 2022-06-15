import 'package:flutter/material.dart';

class DetailsAppBar extends AppBar {
  DetailsAppBar({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(
          key: key,
          title: Text(label),
          actions: [
            IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.edit),
            )
          ],
        );

  final String label;
  final VoidCallback onPressed;
}
