import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class CustomerTile extends StatelessWidget {
  const CustomerTile({
    Key? key,
    required this.customer,
  }) : super(key: key);

  final Customers$Query$Customer customer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(
        builder: (context) {
          return ListTile(
            title: Text(
              customer.name,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            dense: true,
          );
        },
      ),
    );
  }
}
