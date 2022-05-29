import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/pages/unit/units_list_cubit.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/empty_list.dart';
import 'unit_tile.dart';

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
    return QueryBuilder<ResourceListData<Units$Query$Unit>, UnitsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, units, _) {
        if (units.items.isEmpty) {
          return const EmptyList(
            message: "No Units found, Please create some",
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            final unit = units.items[index];

            return UnitTile(unit: unit);
          },
          itemCount: units.items.length,
        );
      },
    );
  }
}
