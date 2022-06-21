import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';
import 'order_page_cubit.dart';

class OrderWrapper extends StatelessWidget {
  const OrderWrapper({
    Key? key,
    required this.id,
    required this.builder,
  }) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Order$Query$Order) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return OrderPageCubit(
          RepositoryProvider.of<OrderRepository>(context),
        );
      },
      child: QueryBuilder<Order$Query$Order, OrderPageCubit>(
        retry: (cubit) => cubit.fetch(id),
        initializer: (cubit) => cubit.fetch(id),
        builder: (context, data, _) {
          return builder(context, data);
        },
      ),
    );
  }
}
