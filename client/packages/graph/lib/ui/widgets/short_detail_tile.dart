import 'package:flutter/material.dart';

/// This will be used everywhere where we details appear
/// todo create Discriprtoon Tile
class ShortDetailTile extends StatelessWidget {
  const ShortDetailTile({
    Key? key,
    required this.subtitle,
    this.value,
    this.onTap,
    this.onEdit,
  }) : super(key: key);

  final String subtitle;
  final String? value;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        value ?? "",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(subtitle),
    );
  }
}
