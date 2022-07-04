import 'package:flutter/material.dart';

import 'customer_form.dart';
import 'customer_wrapper.dart';

class EditCustomerPage extends StatelessWidget {
  const EditCustomerPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Customer"),
      ),
      body: CustomerWrapper(
        id: id,
        builder: (context, customer) {
          return CustomerForm(
            customer: customer,
            id: id,
          );
        },
      ),
    );
  }
}
