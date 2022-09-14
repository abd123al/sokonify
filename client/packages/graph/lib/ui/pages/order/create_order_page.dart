import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../category/pricing_builder.dart';
import '../inventory/items_list.dart';
import 'new_order_cubit.dart';
import 'order_form.dart';

class CreateOrderPage extends StatelessWidget {
  const CreateOrderPage({
    Key? key,
    this.isOrder = true,
  }) : super(key: key);

  final bool isOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isOrder ? "New Order" : "New Sales"),
      ),
      body: PricingBuilder(
        builder: (context, list) {
          buildForm(Categories$Query$Category pricing) {
            return OrderForm<NewOrderCubit>(
              isOrder: isOrder,
              pricingId: pricing.id,
            );
          }

          if (list.items.length == 1) {
            return buildForm(list.items[0]);
          }

          return Tabbed(
            builder: (context, cat) {
              return BlocProvider(
                create: (context) {
                  return NewOrderCubit(isOrder, cat.id);
                },
                child: buildForm(cat),
              );
            },
            categories: list.items,
          );
        },
      ),
    );
  }
}
