import 'package:flutter/material.dart';
import 'package:graph/ui/helpers/helpers.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/permission_builder.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    Key? key,
    required this.item,
    this.currency = "TZS",
    this.color,
    required this.pricingId,
  }) : super(key: key);

  final Items$Query$Item item;
  final String currency;
  final Color? color;
  final int pricingId;

  static String formatItemName(Items$Query$Item item) {
    final n = item.product.name;
    final b = item.brand?.name;

    if (b != null) {
      return "$b - $n";
    }

    return n;
  }

  static String price(Items$Query$Item item, int pricingId) {
    return item.prices.firstWhere((e) => e.categoryId == pricingId).amount;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Builder(
        builder: (context) {
          final name = formatItemName(item);

          return ListTile(
            title: Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: PermissionBuilder(
              type: PermissionType.viewStockQuantity,
              builder: (context) {
                return Text(
                  "${item.quantity} ${item.unit.name}",
                  style: Theme.of(context).textTheme.titleSmall,
                );
              },
            ),
            dense: true,
            trailing: Builder(
              builder: (context) {
                final amount = price(item, pricingId);

                return Text(
                  formatCurrency(amount),
                  style: Theme.of(context).textTheme.titleMedium,
                );
              },
            ),
            onTap: () => redirectTo(context, "${Routes.item}/${item.id}"),
          );
        },
      ),
    );
  }
}
