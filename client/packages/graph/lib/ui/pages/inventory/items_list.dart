import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/empty_list.dart';
import 'items_list_cubit.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<ItemPartsMixin>, ItemsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, items, _) {
        if (items.items.isEmpty) {
          return const EmptyList(
            message: "No items found, Please add some",
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            final item = items.items[index];

            return Card(
              elevation: 16,
              child: ListTile(
                title: Text(
                  item.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "${item.quantity}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                trailing: Text(
                  item.sellingPrice,
                  style: Theme.of(context).textTheme.titleMedium,
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
