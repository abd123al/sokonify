import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ItemRepository {
  final GraphQLClient client;

  ItemRepository( this.client);

  createItem(ItemInput input) {
    final options = MutationOptions(
      document: CREATE_ITEM_MUTATION_DOCUMENT,
      variables: CreateItemArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchItems(ItemsArgs args) {
    final options = QueryOptions(
      document: ITEMS_QUERY_DOCUMENT,
      variables: ItemsArguments(args: args).toJson(),
    );

    return client.query(options);
  }
}
