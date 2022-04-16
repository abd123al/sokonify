import 'package:blocitory/blocitory.dart';

import '../../gql/generated/graphql_api.graphql.dart';
import '../../repositories/store_repository.dart';

class StoresListCubit
    extends ResourceCubit<ResourceListData<Stores$Query$Store>> {
  final StoreRepository _repository;

  StoresListCubit(this._repository) : super();

  fetchStores() {
    super.execute(
      executor: () => _repository.fetchStores(),
      parser: (r) {
        final result = Stores$Query.fromJson(r).stores;
        return ResourceListData(items: result);
      },
    );
  }

  addStore(Stores$Query$Store wallet) {
    final list = state.data?.items;
    list?.insert(0, wallet);

    super.update(state.data?.copyWith(
      items: list,
      addedItems: [wallet],
    ));
  }
}
