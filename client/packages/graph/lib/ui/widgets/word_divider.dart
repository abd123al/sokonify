import 'package:flutter/material.dart';

class WordDivider extends StatelessWidget {
  const WordDivider({
    Key? key,
    required this.text,
    this.padding,
  }) : super(key: key);

  final String text;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8,
            ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }
}
