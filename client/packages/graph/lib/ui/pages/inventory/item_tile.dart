import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    Key? key,
    required this.item,
    this.currency = "TZS",
  }) : super(key: key);

  final Items$Query$Item item;
  final String currency;

  static formatItemName(Items$Query$Item item) {
    final n = item.product.name;
    final b = item.brand?.name;

    if (b != null) {
      return "$n ($b)";
    }

    return n;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(
        builder: (context) {
          final name = formatItemName(item);

          return ListTile(
            title: Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "${item.quantity}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            dense: true,
            trailing: Text(
              "${item.sellingPrice} $currency",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        },
      ),
    );
  }
}
