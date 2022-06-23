import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';

class CustomerTile extends StatelessWidget {
  const CustomerTile({
    Key? key,
    required this.customer,
    this.color,
  }) : super(key: key);

  final Customers$Query$Customer customer;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Builder(
        builder: (context) {
          return ListTile(
            title: Text(
              customer.name,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            dense: true,
            onTap: () {
              redirectTo(context, "${Routes.customer}/${customer.id}");
            },
          );
        },
      ),
    );
  }
}
