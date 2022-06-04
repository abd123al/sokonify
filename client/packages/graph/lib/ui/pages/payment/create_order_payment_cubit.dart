import 'package:blocitory/blocitory.dart';
import 'package:graph/repositories/payment_repository.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class CreatePaymentCubit
    extends ResourceCubit<CreateOrderPayment$Mutation$Payment> {
  CreatePaymentCubit(this._repository, this.onSuccess) : super();

  final PaymentRepository _repository;

  final Function() onSuccess;

  submitOrderPayment(OrderPaymentInput input) {
    super.execute(
      executor: () => _repository.createOrderPayment(input),
      parser: (r) {
        return CreateOrderPayment$Mutation
            .fromJson(r)
            .createOrderPayment;
      },
      onSuccess: (t) => onSuccess(),
    );
  }

  submitSalesPayment(SalesInput input) {
    super.execute(
      executor: () => _repository.createSalesPayment(input),
      parser: (r) {
        final result = CreateSales$Mutation
            .fromJson(r)
            .createSales;

        return CreateOrderPayment$Mutation$Payment.fromJson(result.toJson());
      },
      onSuccess: (t) => onSuccess(),
    );
  }

  submitExpensePayment(ExpensePaymentInput input) {
    super.execute(
      executor: () => _repository.createExpensePayment(input),
      parser: (r) {
        final result = CreateExpensePayment$Mutation.fromJson(r).createExpensePayment;
        return CreateOrderPayment$Mutation$Payment.fromJson(result.toJson());
      },
      onSuccess: (t) => onSuccess(),
    );
  }
}
