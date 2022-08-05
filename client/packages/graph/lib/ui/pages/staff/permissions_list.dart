import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graph/gql/generated/graphql_api.dart';

import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';
import 'permissions_wrapper.dart';

class PermissionsWidget extends StatelessWidget {
  const PermissionsWidget({
    Key? key,
    required this.id,
    required this.type,
  }) : super(key: key);

  final int id;
  final CategoryType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _build(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => redirectTo(
          context,
          Routes.createCategory,
          args: type,
        ),
        tooltip: 'Add',
        icon: const Icon(Icons.edit),
        label: const Text("Edit"),
      ),
    );
  }

  Widget _build() {
    return PermissionsWrapper(
      roleId: id,
      type: type,
      builder: (context, data, word) {
        return SearchableList<Permissions$Query$Permission>(
          builder: (context, e, color) {
            return Builder(
              builder: (context) {
                final title = () {
                  if (e.permission != null) {
                    return describeEnum(e.permission!);
                  } else if (e.pricing != null) {
                    return e.pricing!.name;
                  }

                  return "--";
                }();

                final subtitle = () {
                  if (e.permission == PermissionType.all) {
                    return "Staff can do everything with this permission.";
                  }

                  return "";
                }();

                return ListTile(
                  title: Text(title),
                  subtitle: Text(subtitle),
                );
              },
            );
          },
          compare: (e) {
            if (e.permission != null) {
              return describeEnum(e.permission!);
            } else if (e.pricing != null) {
              return e.pricing!.name;
            }
            return "";
          },
          data: data,
          hintName: word,
        );
      },
    );
  }
}
