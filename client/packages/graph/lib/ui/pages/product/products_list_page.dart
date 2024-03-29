import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/fab.dart';
import '../../widgets/searchable_list.dart';
import 'product_tile.dart';
import 'products_list_cubit.dart';

//todo show product count
class ProductList extends StatelessWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Products$Query$Product>,
        ProductsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        return SearchableList<Products$Query$Product>(
          hintName: "Product",
          data: data,
          compare: (i) => i.name,
          builder: (context, item, color) {
            return ProductTile(
              product: item,
              color: color,
            );
          },
        );
      },
    );
  }
}

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: const ProductList(),
      floatingActionButton: Fab(
        route: Routes.createProduct,
        title: "Add Product",
        permission: PermissionType.createProduct,
      ),
    );
  }
}
