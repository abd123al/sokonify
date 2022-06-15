import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/widgets/widgets.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
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
      builder: (context, data, _) {
        return SearchableList<Categories$Query$Category>(
          hintName: "Category",
          data: data,
          compare: (i) => i.name,
          builder: (context, item, color) {
            return CategoryTile(
              category: item,
              color: color,
            );
          },
        );
      },
    );
  }
}
