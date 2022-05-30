import 'package:flutter/material.dart';

import '../../../nav/nav.dart';
import 'expense_categories_list.dart';

class ExpensesListPage extends StatelessWidget {
  const ExpensesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses Categories"),
      ),
      body: const ExpensesList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => redirectTo(context, Routes.createExpense),
        tooltip: 'Add',
        icon: const Icon(Icons.add),
        label: const Text("New Category"),
      ),
    );
  }
}
