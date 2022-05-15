import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';

//todo create paginated cubit too
class OrdersListCubit
    extends ResourceCubit<ResourceListData<Orders$Query$Order>> {
  final OrderRepository _repository;

  OrdersListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchOrders(
        OrdersArgs(
          mode: FetchMode.full,
          by: OrdersBy.store,
        ),
      ),
      parser: (r) {
        final result = Orders$Query.fromJson(r).orders;
        return ResourceListData(items: result);
      },
    );
  }

  addOrder(Orders$Query$Order order) {
    final list = state.data?.items;
    list?.insert(0, order);

    super.update(state.data?.copyWith(
      items: list,
      addedItems: [order],
    ));
  }
}
