import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/product_repository.dart';
import '../../../repositories/store_repository.dart';

class StorePageCubit extends ResourceCubit<CurrentStore$Query$Store?> {
  final StoreRepository _repository;

  StorePageCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchCurrentStore(),
      parser: (r) => CurrentStore$Query.fromJson(r).currentStore,
    );
  }
}
