import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/stats_repository.dart';

class DailyStatsCubit extends ResourceCubit<DailyStats$Query> {
  final StatsRepository _repository;

  DailyStatsCubit(this._repository) : super();

  fetch(StatsArgs args) {
    super.execute(
      executor: () => _repository.fetchDailySales(args),
      parser: (r) => DailyStats$Query.fromJson(r),
    );
  }
}
