import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/expense_repository.dart';
import '../../../repositories/item_repository.dart';

class ExpensesListCubit extends ResourceListCubit<Expenses$Query$Expense> {
  final ExpenseRepository _repository;

  ExpensesListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchExpenses(
        ExpensesArgs(
          by: ExpensesBy.store,
        ),
      ),
      parser: (r) {
        final result = Expenses$Query.fromJson(r).expenses;
        return ResourceListData(items: result);
      },
    );
  }
}
