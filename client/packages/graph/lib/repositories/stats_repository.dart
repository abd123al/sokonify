import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StatsRepository {
  final GraphQLClient client;

  StatsRepository(this.client);

  fetch(StatsArgs args) {
    final options = QueryOptions(
      document: STATS_QUERY_DOCUMENT,
      variables: StatsArguments(args: args).toJson(),
    );

    return client.query(options);
  }

  fetchItemsStats() {
    final options = QueryOptions(
      document: ITEMS_STATS_QUERY_DOCUMENT,
    );

    return client.query(options);
  }

  fetchSubStats(StatsArgs args) {
    final options = QueryOptions(
      document: SUB_STATS_QUERY_DOCUMENT,
      variables: StatsArguments(args: args).toJson(),
    );

    return client.query(options);
  }
}
