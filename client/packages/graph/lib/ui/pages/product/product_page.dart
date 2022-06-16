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
              redirectTo(
                context,
                "${Routes.editProduct}/$id",
                replace: true,
              );
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
    return ListView(
      children: [
        ShortDetailTile(subtitle: "Product Name", value: data.name),
        const Divider(),
        ShortDetailTile(subtitle: "Description", value: data.description),
        const Divider(),
        ShortDetailTile(subtitle: "Created By", value: data.creator?.name),
        ShortDetailTile(
            subtitle: "Created on", value: data.createdAt.toString()),
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
