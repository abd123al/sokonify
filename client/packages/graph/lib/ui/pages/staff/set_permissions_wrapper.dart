import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/staff_repository.dart';
import 'set_permissions_cubit.dart';

class SetPermissionsWrapper extends StatelessWidget {
  const SetPermissionsWrapper({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext, SetPermissionsCubit) builder;

  @override
  Widget build(BuildContext context) {
    return MutationBuilder<dynamic, SetPermissionsCubit, StaffRepository>(
      blocCreator: (r) => SetPermissionsCubit(r),
      pop: true,
      builder: (context, cubit) {
        return builder(context, cubit);
      },
    );
  }
}
