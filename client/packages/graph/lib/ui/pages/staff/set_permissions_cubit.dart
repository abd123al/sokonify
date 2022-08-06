import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/staff_repository.dart';

class SetPermissionsCubit extends ResourceListCubit<dynamic> {
  final StaffRepository _repository;

  SetPermissionsCubit(this._repository) : super();

  submit(PermissionsInput input) {
    super.execute(
      executor: () => _repository.setPermissions(input),
      parser: (r) {
        return ResourceListData(
          items: SetPermissions$Mutation.fromJson(r).setPermissions,
        );
      },
    );
  }
}
