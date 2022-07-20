import 'package:flutter/material.dart';

class Topper extends StatelessWidget {
  const Topper({
    Key? key,
    required this.label,
    this.onPressed,
    this.actionLabel = "More",
  }) : super(key: key);

  final String label;
  final String actionLabel;
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
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onPressed != null)
              TextButton(
                onPressed: onPressed,
                child: Text(actionLabel),
              )
          ],
        ),
      ),
    );
  }
}
