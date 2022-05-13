import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final String title;
  final dynamic value;
  final MaterialColor? color;
  final String? subtitle;

  const StatTile({
    Key? key,
    required this.title,
    required this.value,
    this.color,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: color?.shade50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$value',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Text(
                  '$subtitle',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
