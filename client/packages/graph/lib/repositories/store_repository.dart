import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StoreRepository {
  final GraphQLClient client;

  StoreRepository(this.client);

  createStore(StoreInput input) {
    final options = MutationOptions(
      document: CREATE_STORE_MUTATION_DOCUMENT,
      variables: CreateStoreArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  editStore(int id, StoreInput input) {
    final options = MutationOptions(
      document: EDIT_STORE_MUTATION_DOCUMENT,
      variables: EditStoreArguments(id: id, input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchStores() {
    final options = QueryOptions(
      document: StoresQuery().document,
    );

    return client.query(options);
  }

  fetchCurrentStore() {
    final options = QueryOptions(
      document: CurrentStoreQuery().document,
    );

    return client.query(options);
  }
}
