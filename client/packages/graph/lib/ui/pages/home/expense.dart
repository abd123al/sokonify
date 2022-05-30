import 'package:flutter/material.dart';
import 'package:graph/gql/generated/graphql_api.graphql.dart';

import '../payment/payments_list.dart';

class Expenses extends StatelessWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const PaymentsList(
        type: PaymentType.expense,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.explicit_outlined),
        label: const Text("New Expense"),
      ),
    );
  }
}
