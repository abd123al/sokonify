import 'package:blocitory/blocitory.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import '../../../../repositories/stats_repository.dart';

class StatsCubit extends ResourceCubit<Stats$Query> {
  final StatsRepository _repository;

  StatsCubit(this._repository) : super();

  fetch(StatsArgs args) {
    super.execute(
      executor: () => _repository.fetch(args),
      parser: (r) => Stats$Query.fromJson(r),
    );
  }

  fetchByDates(TimeframeType timeframe) {
    super.execute(
      executor: () => _repository.fetch(
        StatsArgs(
          timeframe: timeframe,
        ),
      ),
      parser: (r) => Stats$Query.fromJson(r),
    );
  }

  fetchSubStats(StatsArgs args) {
    super.execute(
      executor: () => _repository.fetchSubStats(args),
      parser: (r) => Stats$Query.fromJson(r),
    );
  }
}
