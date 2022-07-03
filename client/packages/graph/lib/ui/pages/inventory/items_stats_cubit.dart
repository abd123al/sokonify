import 'package:blocitory/blocitory.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import '../../../../repositories/stats_repository.dart';

/// This holds simple stat sata
class ItemsStatsCubit extends ResourceCubit<List<ItemsStats$Query$ItemsStats>> {
  final StatsRepository _repository;

  ItemsStatsCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchItemsStats(),
      parser: (r) => ItemsStats$Query.fromJson(r).itemsStats,
    );
  }
}
