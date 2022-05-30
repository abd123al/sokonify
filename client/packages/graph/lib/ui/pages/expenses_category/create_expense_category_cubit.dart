import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/expense_repository.dart';
import '../../../repositories/item_repository.dart';
import '../../../repositories/store_repository.dart';

class CreateExpenseCategoryCubit extends ResourceCubit<CreateExpense$Mutation$Expense> {
  CreateExpenseCategoryCubit(this._repository) : super();
  final ExpenseRepository _repository;

  submit(ExpenseInput input) {
    super.execute(
      executor: () => _repository.createExpense(input),
      parser: (r) {
        return CreateExpense$Mutation.fromJson(r).createExpense;
      },
    );
  }
}
