import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UnitRepository {
  final GraphQLClient client;

  UnitRepository( this.client);

  createUnit(UnitInput input) {
    final options = MutationOptions(
      document: CREATE_UNIT_MUTATION_DOCUMENT,
      variables: CreateUnitArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchUnits() {
    final options = QueryOptions(
      document: UnitsQuery().document,
    );

    return client.query(options);
  }
}
