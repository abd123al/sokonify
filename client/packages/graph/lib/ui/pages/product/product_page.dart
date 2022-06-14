import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:graph/nav/redirect_to.dart';
import 'package:graph/ui/widgets/widgets.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/routes.dart';
import '../brand/brand_tile.dart';
import 'product_wrapper.dart';

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
        title: const Text("Product"),
        actions: [
          IconButton(
            onPressed: () {
              redirectTo(context, "${Routes.editProduct}/$id");
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: ProductWrapper(
        id: id,
        builder: builder,
      ),
    );
  }

  Widget builder(BuildContext context, Product$Query$Product data) {
    _buildTile(
      String key,
      String? value, {
      VoidCallback? onTap,
    }) {
      return ListTile(
        title: Text(
          value ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(key),
      );
    }

    return ListView(
      children: [
        _buildTile("Product Name", data.name),
        const Divider(),
        _buildTile("Description", data.description),
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
  }
}
