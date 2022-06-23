import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'new_order_cubit.dart';
import 'order_form.dart';
import 'order_wrapper.dart';

class EditOrderPage extends StatelessWidget {
  const EditOrderPage({
    Key? key,
    required this.id,
  }) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Order"),
      ),
      body: OrderWrapper(
        id: id,
        builder: (context, o) {
          return BlocProvider(
            create: (context) {
              return EditOrderCubit(
                NewOrder(
                  customer: o.customer != null
                      ? Customers$Query$Customer.fromJson(o.customer!.toJson())
                      : null,
                  items: o.orderItems
                      .map((e) => NewOrderItem(
                            item: Items$Query$Item.fromJson(e.item.toJson()),
                            quantity: e.quantity,
                          ))
                      .toList(),
                ),
              );
            },
            child:  OrderForm<EditOrderCubit>(
              isOrder: true,
              order: o,
              id: id,
            ),
          );
        },
      ),
    );
  }
}
