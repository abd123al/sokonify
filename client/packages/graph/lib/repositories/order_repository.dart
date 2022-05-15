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

  fetchOrders(OrdersArgs args) {
    final options = QueryOptions(
      document: ORDERS_QUERY_DOCUMENT,
      variables: OrdersArguments(args: args).toJson(),
    );

    return client.query(options);
  }
}
