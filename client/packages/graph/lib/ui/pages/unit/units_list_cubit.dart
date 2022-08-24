import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/unit_repository.dart';

class UnitsListCubit extends ResourceListCubit<Units$Query$Unit> {
  final UnitRepository _repository;

  UnitsListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchUnits(),
      parser: (r) {
        final result = Units$Query.fromJson(r).units;
        return ResourceListData(items: result);
      },
    );
  }
}
