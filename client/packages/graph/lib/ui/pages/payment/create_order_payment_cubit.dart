import 'package:blocitory/blocitory.dart';
import 'package:graph/repositories/payment_repository.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class CreateOrderPaymentCubit
    extends ResourceCubit<CreateOrderPayment$Mutation$Payment> {
  CreateOrderPaymentCubit(this._repository) : super();

  final PaymentRepository _repository;

  submitOrderPayment(OrderPaymentInput input) {
    super.execute(
      executor: () => _repository.createOrderPayment(input),
      parser: (r) {
        return CreateOrderPayment$Mutation.fromJson(r).createOrderPayment;
      },
    );
  }
}
