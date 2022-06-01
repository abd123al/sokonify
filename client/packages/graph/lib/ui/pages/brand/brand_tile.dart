import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class BrandTile extends StatelessWidget {
  const BrandTile({
    Key? key,
    required this.expense,
    this.color,
  }) : super(key: key);

  final Brands$Query$Brand expense;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ListTile(
          tileColor: color,
          title: Text(
            expense.name,
            overflow: TextOverflow.ellipsis,
          ),
          dense: true,
        );
      },
    );
  }
}
