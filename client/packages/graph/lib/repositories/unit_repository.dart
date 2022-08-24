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

  editUnit(EditUnitArguments input) {
    final options = MutationOptions(
      document: EDIT_UNIT_MUTATION_DOCUMENT,
      variables: input.toJson(),
    );

    return client.mutate(options);
  }


  fetchUnit(int id) {
    final options = QueryOptions(
        document: UNIT_QUERY_DOCUMENT,
        variables: UnitArguments(id: id).toJson());

    return client.query(options);
  }

  fetchUnits() {
    final options = QueryOptions(
      document: UnitsQuery().document,
    );

    return client.query(options);
  }
}
