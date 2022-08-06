import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/pages/unit/units_list_cubit.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';
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
      floatingActionButton: PermissionBuilder(
        type: PermissionType.createUnit,
        builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () => redirectTo(context, Routes.createUnit),
            tooltip: 'Add Unit',
            icon: const Icon(Icons.add),
            label: const Text("Add Unit"),
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    return QueryBuilder<ResourceListData<Units$Query$Unit>, UnitsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        return SearchableList<Units$Query$Unit>(
          hintName: "Unit",
          data: data,
          compare: (i) => i.name,
          builder: (context, item, color) {
            return UnitTile(
              unit: item,
              color: color,
            );
          },
        );
      },
    );
  }
}
