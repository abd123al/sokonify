import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/repositories.dart';
import 'store_page_cubit.dart';

/// There is no need at all to edit posted order.
class StoreWrapper extends StatelessWidget {
  const StoreWrapper({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext, CurrentStore$Query$Store) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return StorePageCubit(
          RepositoryProvider.of<StoreRepository>(context),
        );
      },
      child: QueryBuilder<CurrentStore$Query$Store?, StorePageCubit>(
        retry: (cubit) => cubit.fetch(),
        initializer: (cubit) => cubit.fetch(),
        builder: (context, data, _) {
          if (data == null) {
            return const Center(child: Text("No store"));
          }

          return builder(context, data);
        },
      ),
    );
  }
}
