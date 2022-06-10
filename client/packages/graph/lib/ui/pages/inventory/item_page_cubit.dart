import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';
import '../../../repositories/order_repository.dart';

class ItemPageCubit extends ResourceCubit<Item$Query$Item> {
  final ItemRepository _repository;

  ItemPageCubit(this._repository) : super();

  fetch(int id) {
    super.execute(
      executor: () => _repository.fetchItem(id),
      parser: (r) => Item$Query.fromJson(r).item,
    );
  }
}
