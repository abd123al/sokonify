import 'package:flutter/material.dart';
import 'package:graph/gql/generated/graphql_api.graphql.dart';

import '../../../nav/nav.dart';
import '../payment/payments_list.dart';
import '../payment/payments_list_cubit.dart';

class Expenses extends StatelessWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const PaymentsList<ExpensesListCubit>(
        type: PaymentType.expense,
        topper: SizedBox(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => redirectTo(context, Routes.createExpensePayment),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
        label: const Text("Track Expense"),
      ),
    );
  }
}
