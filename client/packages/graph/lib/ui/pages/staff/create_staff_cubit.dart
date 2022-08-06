import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/staff_repository.dart';

class CreateStaffCubit extends ResourceCubit<CreateStaff$Mutation$Staff> {
  final StaffRepository _repository;

  CreateStaffCubit(this._repository) : super();

  create(StaffInput input) {
    super.execute(
      executor: () => _repository.createStaff(input),
      parser: (r) {
        return CreateStaff$Mutation.fromJson(r).createStaff;
      },
    );
  }
}
