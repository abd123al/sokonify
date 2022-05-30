import 'package:blocitory/blocitory.dart';
import 'package:graph/repositories/payment_repository.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class TrackExpenseCubit
    extends ResourceCubit<CreateExpensePayment$Mutation$Payment> {
  TrackExpenseCubit(this._repository) : super();

  final PaymentRepository _repository;

  submitExpensePayment(ExpensePaymentInput input) {
    super.execute(
      executor: () => _repository.createExpensePayment(input),
      parser: (r) {
        return CreateExpensePayment$Mutation.fromJson(r).createExpensePayment;
      },
    );
  }
}
