import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class UnitTile extends StatelessWidget {
  const UnitTile({
    Key? key,
    required this.unit,
  }) : super(key: key);

  final Units$Query$Unit unit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        unit.name,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
