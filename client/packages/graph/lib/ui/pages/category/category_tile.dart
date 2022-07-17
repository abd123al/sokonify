import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    Key? key,
    required this.category,
    this.color,
  }) : super(key: key);

  final Categories$Query$Category category;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 16,
      child: ListTile(
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        onTap: () {
          var route = Routes.category;

          if (category.type == CategoryType.role) {
            route = Routes.role;
          }

          redirectTo(
            context,
            "$route/${category.id}",
            args: category.name,
          );
        },
      ),
    );
  }
}
