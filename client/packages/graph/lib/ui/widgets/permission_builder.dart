import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'store_builder_cubit.dart';

/// This is only used for things which needs permission
class PermissionBuilder extends StatelessWidget {
  const PermissionBuilder({
    Key? key,
    required this.builder,
    required this.type,
    this.noAccessWidget = const SizedBox.shrink(),
  }) : super(key: key);

  final Widget Function(BuildContext ctx) builder;
  final Widget noAccessWidget;
  final PermissionType type;

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<CurrentStore$Query$Store?, StoreBuilderCubit>(
      retry: (cubit) => cubit.fetch(),
      loadingWidget: const LoadingIndicator.small(),
      retryWidget: const SizedBox.shrink(),
      builder: (context, store, _) {
        if (store == null) {
          return const Center(child: Icon(Icons.no_accounts));
        }

        final ps = store.permissions.map((e) => e.permission);

        if (ps.contains(PermissionType.all) || ps.contains(type)) {
          return builder(context);
        }

        return noAccessWidget;
      },
    );
  }
}
