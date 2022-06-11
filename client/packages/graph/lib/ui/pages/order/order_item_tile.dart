import 'package:flutter/material.dart';
import 'package:graph/ui/helpers/helpers.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({
    Key? key,
    required this.orderItem,
    this.currency = "TZS",
    this.color,
  }) : super(key: key);

  final OrderItemPartsMixin orderItem;
  final String currency;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Builder(
        builder: (context) {
          return ListTile(
            title: Text(
              "${orderItem.item.product.name} ${orderItem.item.brand?.name ?? ""}",
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              formatCurrency(orderItem.subTotalPrice),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            subtitle: Text(
              "${orderItem.quantity} ${orderItem.item.unit.name}",
            ),
          );
        },
      ),
    );
  }
}
