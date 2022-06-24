import 'package:flutter/material.dart';

class Topper extends StatelessWidget {
  const Topper({
    Key? key,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (onPressed != null)
              TextButton(
                onPressed: onPressed,
                child: const Text('More'),
              )
          ],
        ),
      ),
    );
  }
}
