import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';

class CreateOrderCubit extends ResourceCubit<CreateOrder$Mutation$Order> {
  CreateOrderCubit(this._repository) : super();
  final OrderRepository _repository;

  submit(OrderInput input) {
    super.execute(
      executor: () => _repository.createOrder(input),
      parser: (r) {
        return CreateOrder$Mutation.fromJson(r).createOrder;
      },
    );
  }


  edit(EditOrderArguments args) {
    super.execute(
      executor: () => _repository.editOrder(args),
      parser: (r) {
        final result = EditOrder$Mutation.fromJson(r).editOrder;
        return CreateOrder$Mutation$Order.fromJson(result.toJson());
      },
    );
  }
}
