import 'package:blocitory/helpers/resource_list_data.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/helpers/helpers.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';
import '../category/category_tile.dart';
import '../stats/stats.dart';
import 'item_wrapper.dart';

/// There is no need at all to edit posted order.
class ItemPage extends StatelessWidget {
  const ItemPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(
        label: "Item",
        onPressed: () {
          redirectTo(
            context,
            "${Routes.editItem}/$id",
            replace: true,
          );
        },
      ),
      body: ItemWrapper(
        id: id,
        builder: builder,
      ),
    );
  }

  Widget builder(BuildContext context, Item$Query$Item data) {
    return DetailsList(
      children: [
        SubStats(
          filter: StatsFilter.item,
          id: id,
          name: data.product.name,
        ),
        ShortDetailTile(subtitle: "Item Name", value: data.product.name),
        ShortDetailTile(subtitle: "Brand Name", value: data.brand?.name),
        PermissionBuilder(
          type: PermissionType.viewStockQuantity,
          builder: (context) {
            return ShortDetailTile(
                subtitle: "Quantity", value: data.quantity.toString());
          },
        ),
        ShortDetailTile(subtitle: "Unit", value: data.unit.name),
        ShortDetailTile(subtitle: "Alert Quantity", value: data.alertQuantity.toString()),
        ShortDetailTile(
            subtitle: "Buying Price", value: formatCurrency(data.buyingPrice)),
        const WordDivider(text: "Selling Prices"),
        Builder(
          builder: (context) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.prices.length,
              itemBuilder: (context, index) {
                final item = data.prices[index];

                return ListTile(
                  subtitle: Text(item.category.name),
                  title: Text(
                    item.amount,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              },
            );
          },
        ),
        ShortDetailTile(subtitle: "Description", value: data.description),
        ShortDetailTile(
            subtitle: "Expires at", value: data.expiresAt?.toString()),
        ShortDetailTile(subtitle: "Batch", value: data.batch),
        ShortDetailTile(subtitle: "Added By", value: data.creator?.name),
        ShortDetailTile(subtitle: "Added on", value: data.createdAt.toTime().toString()),
        const WordDivider(text: 'Categories'),
        //todo share one widget
        Builder(
          builder: (context) {
            final items = data.categories
                ?.map((e) => Categories$Query$Category.fromJson(e.toJson()))
                .toList();

            final cats = ResourceListData<Categories$Query$Category>(
              items: items,
            );

            return HighList<Categories$Query$Category>(
              items: cats,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              emptyWord: "No categories found",
              builder: (context, item, color) {
                return CategoryTile(
                  category: item,
                  color: color,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
