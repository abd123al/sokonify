import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'items_list_cubit.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<ItemPartsMixin>, ItemsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, items, _) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final item = items.items[index];

            return Card(
              elevation: 16,
              child: ListTile(
                title: Text(
                  item.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                leading: CircleAvatar(
                  child: Text(item.name.substring(0, 2)),
                ),
              ),
            );
          },
          itemCount: items.items.length,
        );
      },
    );
  }
}
