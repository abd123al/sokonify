import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Orders$Query$Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(
        builder: (context) {
          String formatName() {
            return order.customer?.name ?? "#${order.id}";
          }

          final name = formatName();

          //todo color depending on status
          return ListTile(
            title: Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "${order.createdAt}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            dense: true,
            trailing: Text(
              describeEnum(order.status).toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        },
      ),
    );
  }
}
