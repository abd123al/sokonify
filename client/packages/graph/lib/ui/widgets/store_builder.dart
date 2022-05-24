import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'store_builder_cubit.dart';

class StoreBuilder extends StatelessWidget {
  const StoreBuilder({
    Key? key,
    required this.builder,
    required this.noBuilder,
    this.loadingWidget,
    this.retryWidget,
  }) : super(key: key);

  /// This will be shown when store is not null
  final Widget Function(BuildContext ctx, CurrentStore$Query$Store store)
      builder;

  /// This will be shown when store is null
  final Widget Function(BuildContext ctx) noBuilder;

  /// For showing loading state
  final Widget? loadingWidget;
  final Widget? retryWidget;

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<CurrentStore$Query$Store?, StoreBuilderCubit>(
      retry: (cubit) => cubit.fetch(),
      loadingWidget: loadingWidget,
      retryWidget: retryWidget,
      builder: (context, store, _) {
        if (store == null) {
          return noBuilder(context);
        }

        return builder(context, store);
      },
    );
  }
}
