import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/widgets/widgets.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/product_repository.dart';
import '../brand/brand_tile.dart';
import 'product_page_cubit.dart';

/// There is no need at all to edit posted order.
class ProductPage extends StatelessWidget {
  const ProductPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product #$id"),
      ),
      body: BlocProvider(
        create: (context) {
          return ProductPageCubit(
            RepositoryProvider.of<ProductRepository>(context),
          );
        },
        child: _build(),
      ),
    );
  }

  Widget _build() {
    return QueryBuilder<Product$Query$Product, ProductPageCubit>(
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
            _buildTile("Product Name", data.name),
            const Divider(),
            _buildTile("Description", data.description, onEdit: () {}),
            const Divider(),
            _buildTile("Created By", data.creator?.name),
            _buildTile("Created on", data.createdAt.toString()),
            const WordDivider(text: 'Brands'),
            Builder(
              builder: (context) {
                final items = data.brands
                    .map((e) => Brands$Query$Brand.fromJson(e.toJson()))
                    .toList();

                final brands = ResourceListData<Brands$Query$Brand>(
                  items: items,
                );

                return HighList<Brands$Query$Brand>(
                  items: brands,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  emptyWord: "No brands found",
                  builder: (context, item, color) {
                    return BrandTile(
                      brand: item,
                      color: color,
                    );
                  },
                );
              },
            )
          ],
        );
      },
    );
  }
}
