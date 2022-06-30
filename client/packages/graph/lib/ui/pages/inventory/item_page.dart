import 'package:blocitory/helpers/resource_list_data.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/helpers/helpers.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';
import '../category/category_tile.dart';
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
        ShortDetailTile(subtitle: "Item Name", value: data.product.name),
        ShortDetailTile(subtitle: "Brand Name", value: data.brand?.name),
        ShortDetailTile(subtitle: "Quantity", value: data.quantity.toString()),
        ShortDetailTile(subtitle: "Unit", value: data.unit.name),
        ShortDetailTile(
            subtitle: "Buying Price", value: formatCurrency(data.buyingPrice)),
        //ShortDetailTile(subtitle: "Selling Price", value: formatCurrency(data.sellingPrice)),
        ShortDetailTile(subtitle: "Description", value: data.description),
        ShortDetailTile(
            subtitle: "Expires at", value: data.expiresAt?.toString()),
        ShortDetailTile(subtitle: "Batch", value: data.batch),
        ShortDetailTile(subtitle: "Added By", value: data.creator?.name),
        ShortDetailTile(subtitle: "Added on", value: data.createdAt.toString()),
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
