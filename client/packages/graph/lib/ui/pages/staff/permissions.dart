import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graph/gql/generated/graphql_api.dart';

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
    return PermissionsWrapper(
      roleId: id,
      builder: (context, data) {
        List<Permissions$Query$Permission> list = [];
        String word = "";

        for (var e in data.items) {
          if (type == CategoryType.role) {
            word = "Permission";
            if (e.permission != null) {
              list.add(e);
            }
          } else if (type == CategoryType.pricing) {
            word = "Pricing";
            if (e.pricing != null) {
              list.add(e);
            }
          }
        }

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
          data: data.copyWith(
            items: list,
          ),
          hintName: word,
        );
      },
    );
  }
}
