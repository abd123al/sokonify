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
          type: OrderType.kw$in,
        ),
      ),
      parser: (r) {
        final result = Orders$Query.fromJson(r).orders;
        return ResourceListData(items: result);
      },
    );
  }
}
