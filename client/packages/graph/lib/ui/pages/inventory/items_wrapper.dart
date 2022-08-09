import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'items_list_cubit.dart';

class ItemsWrapper extends StatelessWidget {
  const ItemsWrapper({
    Key? key,
    required this.builder,
     this.productId,
  }) : super(key: key);

  final int? productId;

  final Widget Function(
    BuildContext,
    ResourceListData<Items$Query$Item>,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Items$Query$Item>,
        ItemsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        // final list =
        //     data.items.where((e) => e.product.id == productId).toList();

        return builder(
          context,
          data,
          //data.copyWith(items: list),
        );
      },
    );
  }
}
