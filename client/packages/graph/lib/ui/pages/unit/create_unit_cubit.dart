import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/unit_repository.dart';

class CreateUnitCubit extends ResourceCubit<CreateUnit$Mutation$Unit> {
  CreateUnitCubit(this._repository) : super();
  final UnitRepository _repository;

  create(UnitInput input) {
    super.execute(
      executor: () => _repository.createUnit(input),
      parser: (r) {
        return CreateUnit$Mutation.fromJson(r).createUnit;
      },
    );
  }

  edit(EditUnitArguments arguments) {
    super.execute(
      executor: () => _repository.editUnit(arguments),
      parser: (r) {
        final result = EditUnit$Mutation.fromJson(r).editUnit;
        return CreateUnit$Mutation$Unit.fromJson(result.toJson());
      },
    );
  }
}
