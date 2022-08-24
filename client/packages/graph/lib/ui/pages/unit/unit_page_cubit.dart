import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/brand_repository.dart';
import '../../../repositories/unit_repository.dart';

class UnitCubit extends ResourceCubit<Unit$Query$Unit> {
  final UnitRepository _repository;

  UnitCubit(this._repository) : super();

  fetch(int id) {
    super.execute(
      executor: () => _repository.fetchUnit(id),
      parser: (r) => Unit$Query.fromJson(r).unit,
    );
  }
}
