import 'package:graphql_flutter/graphql_flutter.dart';

import '../gql/generated/graphql_api.graphql.dart';

class CustomerRepository {
  final GraphQLClient client;

  CustomerRepository(this.client);

  createCustomer(CustomerInput input) {
    final options = MutationOptions(
      document: CREATE_CUSTOMER_MUTATION_DOCUMENT,
      variables: CreateCustomerArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchCustomers() {
    final options = QueryOptions(
      document: CUSTOMERS_QUERY_DOCUMENT,
    );

    return client.query(options);
  }
}
