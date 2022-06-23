import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';

//todo create paginated cubit too
class OrdersListCubit extends ResourceListCubit<Orders$Query$Order> {
  final OrderRepository _repository;

  OrdersListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchOrders(
        OrdersArgs(
          mode: FetchMode.full,
          by: OrdersBy.store,
          type: OrderType.sale,
        ),
      ),
      parser: (r) {
        final result = Orders$Query.fromJson(r).orders;
        return ResourceListData(items: result);
      },
    );
  }

  changeOrderStatus(int id,OrderStatus status) {
    final order = findItem((e) => e.id == id);

    if (order != null) {
      order.status = status;
      super.updateItem((l) => l.firstWhere((e) => e.id == id), order);
    }
  }
}
