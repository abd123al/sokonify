import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/widgets.dart';
import 'expense_category_tile.dart';
import 'expense_categories_list_cubit.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Expenses$Query$Expense>,
        ExpensesCategoriesListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        return SearchableList<Expenses$Query$Expense>(
          hintName: "Product",
          list: data.items,
          compare: (i) => i.name,
          builder: (context, item) {
            return ExpenseCategoryTile(
              expense: item,
            );
          },
        );
      },
    );
  }
}
