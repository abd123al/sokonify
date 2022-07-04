import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class UnitTile extends StatelessWidget {
  const UnitTile({
    Key? key,
    required this.unit,
    this.color,
  }) : super(key: key);

  final Units$Query$Unit unit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          unit.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        tileColor: color,
      ),
    );
  }
}
