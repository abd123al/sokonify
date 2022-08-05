import 'package:blocitory/blocitory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'categories_list_cubit.dart';

class CategoriesWrapper extends StatelessWidget {
  const CategoriesWrapper({
    Key? key,
    required this.builder,
    required this.type,
  }) : super(key: key);

  final CategoryType type;

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
        final list =
            data.items.where((element) => element.type == type).toList();

        return builder(
          context,
          data.copyWith(items: list),
        );
      },
    );
  }
}
