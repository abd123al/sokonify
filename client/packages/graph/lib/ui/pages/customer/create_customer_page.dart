import 'package:flutter/material.dart';

import 'customer_form.dart';

class CreateCustomerPage extends StatelessWidget {
  const CreateCustomerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Customer"),
      ),
      body: const CustomerForm(
        customer: null,
        id: null,
      ),
    );
  }
}
