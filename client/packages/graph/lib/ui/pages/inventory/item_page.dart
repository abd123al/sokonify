import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/helpers/helpers.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';
import 'item_page_cubit.dart';

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
      appBar: AppBar(
        title: Text("Item #$id"),
      ),
      body: BlocProvider(
        create: (context) {
          return ItemPageCubit(
            RepositoryProvider.of<ItemRepository>(context),
          );
        },
        child: _build(),
      ),
    );
  }

  Widget _build() {
    return QueryBuilder<Item$Query$Item, ItemPageCubit>(
      retry: (cubit) => cubit.fetch(id),
      initializer: (cubit) => cubit.fetch(id),
      builder: (context, data, _) {
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

        return ListView(
          children: [
            _buildTile("Product Name", data.product.name),
            _buildTile("Brand Name", data.brand?.name, onEdit: () {}),
            const Divider(),
            _buildTile("Quantity", data.quantity.toString()),
            _buildTile("Unit", data.unit.name, onEdit: () {}),
            const Divider(),
            _buildTile("Buying Price", formatCurrency(data.buyingPrice)),
            _buildTile("Selling Price", formatCurrency(data.sellingPrice)),
            const Divider(),
            _buildTile("Description", data.description, onEdit: () {}),
            _buildTile("Expires at", data.expiresAt?.toString(), onEdit: () {}),
            _buildTile("Batch", data.batch, onEdit: () {}),
            const Divider(),
            _buildTile("Added By", data.creator?.name),
            _buildTile("Added on", data.createdAt.toString()),
          ],
        );
      },
    );
  }
}
