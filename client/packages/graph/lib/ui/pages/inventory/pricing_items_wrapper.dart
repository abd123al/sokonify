import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'items_list_cubit.dart';

class PricingItemsWrapper extends StatelessWidget {
  const PricingItemsWrapper({
    Key? key,
    required this.builder,
    required this.pricingId,
  }) : super(key: key);

  final int pricingId;

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
        List<Items$Query$Item> items = [];

        for (var e in data.items) {
          if (e.prices.map((e) => e.categoryId).contains(pricingId)) {
            items.add(e);
          }
        }

        return builder(
          context,
          data.copyWith(items: items,),
        );
      },
    );
  }
}
