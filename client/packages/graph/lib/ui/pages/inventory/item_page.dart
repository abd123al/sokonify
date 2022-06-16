import 'package:flutter/material.dart';
import 'package:graph/ui/helpers/helpers.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';
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
    _buildTile(
      String key,
      String? value, {
      VoidCallback? onTap,
      VoidCallback? onEdit,
    }) {
      return ListTile(
        title: Text(
          value ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(key),
        trailing: onEdit != null
            ? TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
              )
            : null,
      );
    }

    return DetailsList(
      children: [
        _buildTile("Item Name", data.product.name),
        _buildTile("Brand Name", data.brand?.name, onEdit: () {}),
        _buildTile("Quantity", data.quantity.toString()),
        _buildTile("Unit", data.unit.name, onEdit: () {}),
        _buildTile("Buying Price", formatCurrency(data.buyingPrice)),
        _buildTile("Selling Price", formatCurrency(data.sellingPrice)),
        _buildTile("Description", data.description, onEdit: () {}),
        _buildTile("Expires at", data.expiresAt?.toString(), onEdit: () {}),
        _buildTile("Batch", data.batch, onEdit: () {}),
        _buildTile("Added By", data.creator?.name),
        _buildTile("Added on", data.createdAt.toString()),
      ],
    );
  }
}
