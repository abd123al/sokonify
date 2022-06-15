import 'package:flutter/material.dart';

class DetailsList extends StatelessWidget {
  const DetailsList({
    Key? key,
    required this.children,
    this.separator,
  }) : super(key: key);

  final List<Widget> children;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return children[index];
      },
      separatorBuilder: (context, index) {
        return separator ?? const Divider();
      },
      itemCount: children.length,
    );
  }
}
