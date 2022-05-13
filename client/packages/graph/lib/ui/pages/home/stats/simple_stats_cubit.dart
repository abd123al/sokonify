import 'package:blocitory/blocitory.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import '../../../../repositories/stats_repository.dart';

/// This holds simple stat sata
/// todo create detailed stats cubit
class SimpleStatsCubit extends ResourceCubit<Stats$Query> {
  final StatsRepository _repository;

  SimpleStatsCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetch(StatsArgs()),
      parser: (r) => Stats$Query.fromJson(r),
    );
  }
}
