import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/staff_repository.dart';

class StaffsListCubit extends ResourceListCubit<Staffs$Query$Staff> {
  final StaffRepository _repository;

  StaffsListCubit(this._repository) : super();

  fetch(int storeId) {
    super.execute(
      executor: () => _repository.fetchStaffsByRole(storeId),
      parser: (r) {
        return ResourceListData(items: Staffs$Query.fromJson(r).staffs);
      },
    );
  }
}
