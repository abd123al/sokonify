import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/high_builder.dart';
import 'categories_list_cubit.dart';
import 'category_tile.dart';

class CategoriesListPage extends StatelessWidget {
  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Categories"),
      ),
      body: _buildListView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => redirectTo(context, Routes.createCategory),
        tooltip: 'Add',
        icon: const Icon(Icons.add),
        label: const Text("Add Category"),
      ),
    );
  }

  Widget _buildListView() {
    return QueryBuilder<ResourceListData<Categories$Query$Category>,
        CategoriesListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, units, _) {
        return HighList<Categories$Query$Category>(
          builder: (context, store, color) {
            return CategoryTile(
              category: store,
              color: color,
            );
          },
          items: units,
        );
      },
    );
  }
}
