import 'package:flutter/material.dart';

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
        builder: (context, order) {
          return const OrderForm(
            isOrder: true,
          );
        },
      ),
    );
  }
}
