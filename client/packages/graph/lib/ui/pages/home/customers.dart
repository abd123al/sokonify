import 'package:flutter/material.dart';

import '../../../nav/nav.dart';
import '../customer/customers_list.dart';

class Customers extends StatelessWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CustomersList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => redirectTo(context, Routes.createCustomer),
        tooltip: 'Register Customer',
        backgroundColor: Colors.brown,
        label: const Text("Register Customer"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}