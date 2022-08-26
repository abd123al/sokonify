import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocProvider(
        create: (context) {
          return NewOrderCubit(isOrder);
        },
        child: OrderForm<NewOrderCubit>(
          isOrder: isOrder,
        ),
      ),
    );
  }
}
