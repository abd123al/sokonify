import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StoreRepository {
  final GraphQLClient client;

  StoreRepository({required this.client});

  createStore(StoreInput input) {
    final _options = MutationOptions(
      document: CREATE_STORE_MUTATION_DOCUMENT,
      variables: CreateStoreArguments(input: input).toJson(),
    );

    return client.mutate(_options);
  }

  fetchStores() {
    final _options = QueryOptions(
      document: StoresQuery().document,
    );

    return client.query(_options);
  }
}
