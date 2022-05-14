import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/pages/unit/units_list_cubit.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/empty_list.dart';

class UnitsListPage extends StatelessWidget {
  const UnitsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Units"),
      ),
      body: _buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => redirectTo(context, Routes.createUnit),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView() {
    return QueryBuilder<ResourceListData<UnitsPartsMixin>, UnitsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, units, _) {
        if (units.items.isEmpty) {
          return const EmptyList(
            message: "No Units found, Please create some",
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
