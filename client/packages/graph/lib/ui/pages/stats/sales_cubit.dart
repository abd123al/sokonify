import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/stats_repository.dart';

class SalesCubit extends ResourceCubit<List<Sales$Query$OrderItem>> {
  final StatsRepository _repository;

  SalesCubit(this._repository) : super();

  fetch(StatsArgs args) {
    super.execute(
      executor: () => _repository.fetchSales(args),
      parser: (r) => Sales$Query.fromJson(r).sales,
    );
  }
}
