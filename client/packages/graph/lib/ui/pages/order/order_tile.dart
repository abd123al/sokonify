import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    Key? key,
    required this.order,
    this.color,
  }) : super(key: key);

  final Orders$Query$Order order;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    /// This will show black for pending orders.
    Color? statusColor;
    if (order.status == OrderStatus.completed) {
      statusColor = Colors.green;
    } else if (order.status == OrderStatus.canceled) {
      statusColor = Colors.red;
    }

    return Card(
      color: color,
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
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: statusColor,
                  ),
            ),
            onTap: () => redirectTo(context, "${Routes.order}/${order.id}"),
          );
        },
      ),
    );
  }
}
