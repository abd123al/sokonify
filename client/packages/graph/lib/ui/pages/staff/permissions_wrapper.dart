import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/staff/permissions_cubit.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/staff_repository.dart';

class PermissionsWrapper extends StatelessWidget {
  const PermissionsWrapper({
    Key? key,
    required this.roleId,
    required this.builder,
  }) : super(key: key);

  final int roleId;
  final Widget Function(
      BuildContext, ResourceListData<Permissions$Query$Permission>) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return PermissionsCubit(
          RepositoryProvider.of<StaffRepository>(context),
        );
      },
      child: QueryBuilder<ResourceListData<Permissions$Query$Permission>,
          PermissionsCubit>(
        retry: (cubit) => cubit.fetch(roleId),
        initializer: (cubit) => cubit.fetch(roleId),
        builder: (context, data, _) {
          return builder(context, data);
        },
      ),
    );
  }
}
