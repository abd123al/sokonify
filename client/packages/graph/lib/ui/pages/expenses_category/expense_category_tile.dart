import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class ExpenseCategoryTile extends StatelessWidget {
  const ExpenseCategoryTile({
    Key? key,
    required this.expense,
  }) : super(key: key);

  final Expenses$Query$Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
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
