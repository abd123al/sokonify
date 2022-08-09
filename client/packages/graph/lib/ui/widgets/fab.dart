import 'package:flutter/material.dart';

import '../../gql/generated/graphql_api.graphql.dart';
import '../../nav/redirect_to.dart';
import 'permission_builder.dart';

class Fab extends StatelessWidget {
  const Fab({
    Key? key,
    this.icon,
    required this.title,
    required this.route,
    required this.permission,
  }) : super(key: key);

  final Widget? icon;
  final String title;
  final String route;
  final PermissionType permission;

  @override
  Widget build(BuildContext context) {
    return PermissionBuilder(
      type: permission,
      builder: (context) {
        return FloatingActionButton.extended(
          onPressed: () => redirectTo(context, route),
          tooltip: title,
          label: Text(title),
          icon: icon ?? const Icon(Icons.add),
        );
      },
    );
  }
}
