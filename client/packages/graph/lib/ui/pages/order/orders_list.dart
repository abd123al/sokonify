import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';
import 'order_tile.dart';
import 'orders_list_cubit.dart';

//todo use [SliverAppBar]
class OrdersListScaffold extends StatelessWidget {
  const OrdersListScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Topper(
            label: "Today Orders",
          ),
          Expanded(
            child: _OrdersList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => redirectTo(context, Routes.createOrder),
        tooltip: 'Add',
        icon: const Icon(Icons.add),
        label: const Text("New Order"),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Orders$Query$Order>, OrdersListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        return SearchableList<Orders$Query$Order>(
          hintName: "Order",
          list: data.items,
          compare: (i) => "${i.customer?.name}${i.id}",
          builder: (context, o) {
            return OrderTile(order: o);
          },
        );
      },
    );
  }
}
