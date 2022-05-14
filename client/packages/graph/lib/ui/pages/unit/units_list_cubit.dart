import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/unit_repository.dart';

class UnitsListCubit extends ResourceCubit<ResourceListData<Units$Query$Unit>> {
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

  addUnit(Units$Query$Unit wallet) {
    final list = state.data?.items;
    list?.insert(0, wallet);

    super.update(state.data?.copyWith(
      items: list,
      addedItems: [wallet],
    ));
  }
}
