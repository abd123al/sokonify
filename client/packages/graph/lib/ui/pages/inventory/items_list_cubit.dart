import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';

class ItemsListCubit extends ResourceListCubit<Items$Query$Item> {
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
}
