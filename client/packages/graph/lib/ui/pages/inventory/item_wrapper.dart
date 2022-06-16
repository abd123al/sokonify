import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';
import 'item_page_cubit.dart';

/// There is no need at all to edit posted order.
class ItemWrapper extends StatelessWidget {
  const ItemWrapper({
    Key? key,
    required this.id,
    required this.builder,
  }) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Item$Query$Item) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ItemPageCubit(
          RepositoryProvider.of<ItemRepository>(context),
        );
      },
      child: QueryBuilder<Item$Query$Item, ItemPageCubit>(
        retry: (cubit) => cubit.fetch(id),
        initializer: (cubit) => cubit.fetch(id),
        builder: (context, data, _) {
          return builder(context, data);
        },
      ),
    );
  }
}
