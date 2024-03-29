import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PaymentRepository {
  final GraphQLClient client;

  PaymentRepository(this.client);

  createOrderPayment(OrderPaymentInput input) {
    final options = MutationOptions(
      document: CREATE_ORDER_PAYMENT_MUTATION_DOCUMENT,
      variables: CreateOrderPaymentArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  createExpensePayment(ExpensePaymentInput input) {
    final options = MutationOptions(
      document: CREATE_EXPENSE_PAYMENT_MUTATION_DOCUMENT,
      variables: CreateExpensePaymentArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchPayments(PaymentsArgs args) {
    final options = QueryOptions(
      document: PAYMENTS_QUERY_DOCUMENT,
      variables: PaymentsArguments(args: args).toJson(),
    );

    return client.query(options);
  }

  createSalesPayment(SalesInput input) {
    final options = MutationOptions(
      document: CREATE_SALES_MUTATION_DOCUMENT,
      variables: CreateSalesArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchPayment(int id) {
    final options = QueryOptions(
      document: PAYMENT_QUERY_DOCUMENT,
      variables: PaymentArguments(id: id).toJson(),
    );

    return client.query(options);
  }
}
