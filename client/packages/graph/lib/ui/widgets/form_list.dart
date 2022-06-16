import 'package:flutter/material.dart';

class FormList extends StatelessWidget {
  const FormList({
    Key? key,
    required this.children,
    this.separator,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);

  final List<Widget> children;
  final Widget? separator;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        return children[index];
      },
      separatorBuilder: (context, index) {
        return separator ??
            const SizedBox(
              height: 16,
            );
      },
      itemCount: children.length,
    );
  }
}
