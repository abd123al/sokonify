import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';

class ItemsListCubit extends ResourceCubit<ResourceListData<Items$Query$Item>> {
  final ItemRepository _repository;

  ItemsListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchItems(
        ItemsArgs(
          by: ItemsBy.store,
          value: 0,
        ),
      ),
      parser: (r) {
        final result = Items$Query.fromJson(r).items;
        return ResourceListData(items: result);
      },
    );
  }

  addItem(Items$Query$Item item) {
    final list = state.data?.items;
    list?.insert(0, item);

    super.update(state.data?.copyWith(
      items: list,
      addedItems: [item],
    ));
  }
}
