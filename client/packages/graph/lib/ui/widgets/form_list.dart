import 'package:flutter/material.dart';

/// todo add padding only here
class FormList extends StatelessWidget {
  const FormList({
    Key? key,
    required this.children,
    this.separator,
    this.shrinkWrap = false,
    this.physics, this.padding,
  }) : super(key: key);

  final List<Widget> children;
  final Widget? separator;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: ListView.separated(
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
      ),
    );
  }
}
