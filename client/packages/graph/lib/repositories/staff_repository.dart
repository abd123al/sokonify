import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StaffRepository {
  final GraphQLClient client;

  StaffRepository(this.client);

  createStaff(StaffInput input) {
    final options = MutationOptions(
      document: CREATE_STAFF_MUTATION_DOCUMENT,
      variables: CreateStaffArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchStaffsByRole(int storeId) {
    final options = QueryOptions(
      document: STAFFS_QUERY_DOCUMENT,
      variables: StaffsArguments(
        args: StaffsArgs(
          value: storeId,
          by: StaffsBy.role,
        ),
      ).toJson(),
    );

    return client.query(options);
  }

  createPermission(PermissionInput input) {
    final options = MutationOptions(
      document: CREATE_PERMISSION_MUTATION_DOCUMENT,
      variables: CreatePermissionArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  deletePermission(int id) {
    final options = MutationOptions(
      document: DELETE_PERMISSION_MUTATION_DOCUMENT,
      variables: DeletePermissionArguments(id: id).toJson(),
    );

    return client.mutate(options);
  }

  fetchPermissions(int roleId) {
    final options = QueryOptions(
      document: PERMISSIONS_QUERY_DOCUMENT,
      variables: PermissionsArguments(
        roleId: roleId,
      ).toJson(),
    );

    return client.query(options);
  }
}
