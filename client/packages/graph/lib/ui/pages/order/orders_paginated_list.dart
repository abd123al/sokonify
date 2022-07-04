import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/order/order_tile.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';

class OrdersPaginatedPage extends StatelessWidget {
  const OrdersPaginatedPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: const OrdersPaginationList(by: OrdersBy.store),
    );
  }
}

class OrdersPaginationList extends StatelessWidget {
  const OrdersPaginationList({
    Key? key,
    this.value,
    required this.by,
  }) : super(key: key);

  final int? value;
  final OrdersBy by;

  @override
  Widget build(BuildContext context) {
    return AutoPagedList<Orders$Query$Order>(
      executor: (context, skip) {
        return RepositoryProvider.of<OrderRepository>(context).fetchOrders(
          OrdersArgs(
            offset: skip,
            limit: 10,
            mode: FetchMode.pagination,
            by: by,
            type: OrderType.sale,
            value: value,
          ),
        );
      },
      parser: (result) => Orders$Query.fromJson(result.data!).orders,
      widgetBuilder: (context, i) {
        return OrderTile(
          order: i,
        );
      },
    );
  }
}
