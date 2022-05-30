import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ExpenseRepository {
  final GraphQLClient client;

  ExpenseRepository( this.client);

  createExpense(ExpenseInput input) {
    final options = MutationOptions(
      document: CREATE_EXPENSE_MUTATION_DOCUMENT,
      variables: CreateExpenseArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchExpenses(ExpensesArgs args) {
    final options = QueryOptions(
      document: EXPENSES_QUERY_DOCUMENT,
      variables: ExpensesArguments(args: args).toJson(),
    );

    return client.query(options);
  }
}
