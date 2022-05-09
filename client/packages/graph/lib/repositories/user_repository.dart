import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserRepository {
  final GraphQLClient client;

  UserRepository( this.client);

  fetchMe() {
    final _options = QueryOptions(
      document: MeQuery().document,
    );

    return client.query(_options);
  }
}
