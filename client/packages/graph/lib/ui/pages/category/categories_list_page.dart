import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/widgets/widgets.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import 'categories_list_cubit.dart';
import 'category_tile.dart';

class CategoriesListPage extends StatelessWidget {
  const CategoriesListPage({
    Key? key,
    required this.type,
  }) : super(key: key);
  final CategoryType type;

  @override
  Widget build(BuildContext context) {
    word() {
      if (type == CategoryType.subcategory) {
        return "Stock";
      } else if (type == CategoryType.pricing) {
        return "Pricing";
      } else if (type == CategoryType.role) {
        return "Staff";
      }
      return "Product";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${word()} Categories"),
      ),
      body: _buildListView(),
      floatingActionButton: PermissionBuilder(
        type: PermissionType.createCategory,
        builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () => redirectTo(
              context,
              Routes.createCategory,
              args: type,
            ),
            tooltip: 'Add',
            icon: const Icon(Icons.add),
            label: const Text("Add Category"),
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    return QueryBuilder<ResourceListData<Categories$Query$Category>,
        CategoriesListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        final List<Categories$Query$Category> cats =
            data.items.where((e) => e.type == type).toList();

        return SearchableList<Categories$Query$Category>(
          hintName: "Category",
          data: data.copyWith(
            items: cats,
          ),
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
