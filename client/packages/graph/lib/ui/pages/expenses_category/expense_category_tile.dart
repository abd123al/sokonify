import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class ExpenseCategoryTile extends StatelessWidget {
  const ExpenseCategoryTile({
    Key? key,
    required this.expense,
    this.color,
  }) : super(key: key);

  final Expenses$Query$Expense expense;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Builder(
        builder: (context) {
          return ListTile(
            title: Text(
              expense.name,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            dense: true,
          );
        },
      ),
    );
  }
}
