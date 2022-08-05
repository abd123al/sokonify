import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'permissions_form.dart';
import 'permissions_wrapper.dart';

class EditPermissions extends StatelessWidget {
  const EditPermissions({
    Key? key,
    required this.roleId,
    required this.type,
  }) : super(key: key);

  final int roleId;
  final CategoryType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Permissions"),
      ),
      body: PermissionsWrapper(
        roleId: roleId,
        type: type,
        builder: (context, list, word) {
          return PermissionsForm(
            id: roleId,
            type: type,
            permissions: list,
          );
        },
      ),
    );
  }
}
