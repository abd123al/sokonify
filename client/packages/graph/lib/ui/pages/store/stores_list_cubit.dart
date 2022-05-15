import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/store_repository.dart';

class StoresListCubit extends ResourceListCubit<Stores$Query$Store> {
  final StoreRepository _repository;

  StoresListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchStores(),
      parser: (r) {
        final result = Stores$Query.fromJson(r).stores;
        return ResourceListData(items: result);
      },
    );
  }
}
