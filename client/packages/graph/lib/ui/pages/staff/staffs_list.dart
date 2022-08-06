import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../../repositories/staff_repository.dart';
import '../../widgets/widgets.dart';
import 'staff_tile.dart';
import 'staffs_list_cubit.dart';

class StaffsList extends StatelessWidget {
  const StaffsList({
    Key? key,
    required this.roleId,
  }) : super(key: key);

  final int roleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      floatingActionButton: PermissionBuilder(
        type: PermissionType.createStaff,
        builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () => redirectTo(
              context,
              "${Routes.editPermissions}/$roleId",
              replace: true,
            ),
            tooltip: 'Add',
            icon: const Icon(Icons.add),
            label: const Text("Add Staff"),
          );
        },
      ),
    );
  }

  Widget _body() {
    return BlocProvider<StaffsListCubit>(
      create: (context) {
        return StaffsListCubit(RepositoryProvider.of<StaffRepository>(context));
      },
      child:
          QueryBuilder<ResourceListData<Staffs$Query$Staff>, StaffsListCubit>(
        retry: (cubit) => cubit.fetch(roleId),
        initializer: (cubit) => cubit.fetch(roleId),
        builder: (context, data, _) {
          return SearchableList<Staffs$Query$Staff>(
            hintName: "Staff",
            data: data,
            compare: (i) => i.user.name,
            builder: (context, item, color) {
              return StaffTile(
                staff: item,
                color: color,
              );
            },
          );
        },
      ),
    );
  }
}
