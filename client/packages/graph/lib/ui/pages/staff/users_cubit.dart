import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/staff_repository.dart';

class UsersCubit extends ResourceListCubit<Users$Query$User> {
  final StaffRepository _repository;

  UsersCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchUsers(),
      parser: (r) {
        return ResourceListData(items: Users$Query.fromJson(r).users);
      },
    );
  }
}
