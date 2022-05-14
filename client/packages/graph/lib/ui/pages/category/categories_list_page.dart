import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/empty_list.dart';
import 'categories_list_cubit.dart';

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
        if (units.items.isEmpty) {
          return const EmptyList(
            message: "No Categories found, Please create some",
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            final store = units.items[index];

            return Card(
              elevation: 16,
              child: ListTile(
                title: Text(
                  store.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                leading: CircleAvatar(
                  child: Text(store.name.substring(0, 2)),
                ),
              ),
            );
          },
          itemCount: units.items.length,
        );
      },
    );
  }
}
