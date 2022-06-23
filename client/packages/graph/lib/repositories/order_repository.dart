import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class OrderRepository {
  final GraphQLClient client;

  OrderRepository(this.client);

  createOrder(OrderInput input) {
    final options = MutationOptions(
      document: CREATE_ORDER_MUTATION_DOCUMENT,
      variables: CreateOrderArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  editOrder(EditOrderArguments args) {
    final options = MutationOptions(
      document: EDIT_ORDER_MUTATION_DOCUMENT,
      variables: args.toJson(),
    );

    return client.mutate(options);
  }

  fetchOrders(OrdersArgs args) {
    final options = QueryOptions(
      document: ORDERS_QUERY_DOCUMENT,
      variables: OrdersArguments(args: args).toJson(),
    );

    return client.query(options);
  }

  fetchOrder(int id) {
    final options = QueryOptions(
      document: ORDER_QUERY_DOCUMENT,
      variables: OrderArguments(id: id).toJson(),
    );

    return client.query(options);
  }
}
