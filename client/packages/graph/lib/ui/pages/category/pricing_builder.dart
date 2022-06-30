import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'categories_list_cubit.dart';

class PricingBuilder extends StatelessWidget {
  const PricingBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(
    BuildContext,
    ResourceListData<Categories$Query$Category>,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Categories$Query$Category>,
        CategoriesListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        final List<Categories$Query$Category> cats = data.items
            .where(
              (e) => e.type == CategoryType.pricing,
            )
            .toList();

        return builder(context, data.copyWith(items: cats));
      },
    );
  }
}
