import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';

class OrderPageCubit extends ResourceCubit<Order$Query$Order> {
  final OrderRepository _repository;

  OrderPageCubit(this._repository) : super();

  fetch(int id) {
    super.execute(
      executor: () => _repository.fetchOrder(id),
      parser: (r) => Order$Query.fromJson(r).order,
    );
  }
}
