import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/staff_repository.dart';

class PermissionsCubit extends ResourceListCubit<Permissions$Query$Permission> {
  final StaffRepository _repository;

  PermissionsCubit(this._repository) : super();

  fetch(int roleId) {
    super.execute(
      executor: () => _repository.fetchPermissions(roleId),
      parser: (r) {
        return ResourceListData(
          items: Permissions$Query.fromJson(r).permissions,
        );
      },
    );
  }
}
