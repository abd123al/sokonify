import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/unit_repository.dart';

class CreateUnitCubit extends ResourceCubit<UnitsPartsMixin> {
  CreateUnitCubit(this._repository) : super();
  final UnitRepository _repository;

  submit(UnitInput input) {
    super.execute(
      executor: () => _repository.createUnit(input),
      parser: (r) {
        return CreateUnit$Mutation.fromJson(r).createUnit;
      },
    );
  }
}
