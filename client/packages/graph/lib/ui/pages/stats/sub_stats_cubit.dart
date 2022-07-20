import 'package:blocitory/blocitory.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import '../../../../repositories/stats_repository.dart';

class SubStatsCubit extends ResourceCubit<SubStats$Query> {
  final StatsRepository _repository;

  SubStatsCubit(this._repository) : super();

  fetch(StatsArgs args) {
    super.execute(
      executor: () => _repository.fetch(args),
      parser: (r) => SubStats$Query.fromJson(r),
    );
  }
}
