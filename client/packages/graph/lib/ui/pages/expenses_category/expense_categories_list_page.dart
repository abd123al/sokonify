import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import 'expense_categories_list.dart';

class ExpensesListPage extends StatelessWidget {
  const ExpensesListPage({Key? key, required this.type}) : super(key: key);
  final ExpenseType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses Categories"),
      ),
      body: ExpensesList(
        type: type,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (type == ExpenseType.out) {
            redirectTo(context, Routes.createExpense);
          } else {
            redirectTo(context, Routes.createGains);
          }
        },
        tooltip: 'Add',
        icon: const Icon(Icons.add),
        label: const Text("New Category"),
      ),
    );
  }
}
