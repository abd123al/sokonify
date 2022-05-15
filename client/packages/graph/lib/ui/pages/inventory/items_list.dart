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
              child: Builder(
                builder: (context) {
                  String formatName() {
                    final n = item.product.name;
                    final b = item.brand?.name;

                    if (b != null) {
                      return "$n ($b)";
                    }

                    return n;
                  }

                  final name = formatName();

                  return ListTile(
                    title: Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "${item.quantity}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    dense: true,
                    trailing: Text(
                      item.sellingPrice,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                },
              ),
            );
          },
          itemCount: items.items.length,
        );
      },
    );
  }
}
