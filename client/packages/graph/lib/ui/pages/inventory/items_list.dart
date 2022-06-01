import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/widgets.dart';
import 'item_tile.dart';
import 'items_list_cubit.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Items$Query$Item>, ItemsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        return SearchableList<Items$Query$Item>(
          hintName: "Item",
          data: data,
          compare: (i) => ItemTile.formatItemName(i),
          builder: (context, item,color) {
            return ItemTile(
              item: item,
              color: color,
            );
          },
        );
      },
    );
  }
}
