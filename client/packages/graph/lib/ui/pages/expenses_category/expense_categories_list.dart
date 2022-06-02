import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/widgets.dart';
import 'expense_categories_list_cubit.dart';
import 'expense_category_tile.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({Key? key, required this.type}) : super(key: key);
  final ExpenseType type;

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Expenses$Query$Expense>,
        ExpensesCategoriesListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        final cats = data.items.where((e) => e.type == type).toList();

        return SearchableList<Expenses$Query$Expense>(
          hintName: type == ExpenseType.kw$in ? "Payment" : "Expense",
          data: data.copyWith(
            items: cats,
          ),
          compare: (i) => i.name,
          builder: (context, item, color) {
            return ExpenseCategoryTile(
              expense: item,
              color: color,
            );
          },
        );
      },
    );
  }
}
