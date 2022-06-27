import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/payment_repository.dart';

class ParentPaymentsListCubit extends ResourceListCubit<Payments$Query$Payment> {
  final PaymentRepository _repository;
  final PaymentType type;

  ParentPaymentsListCubit(this._repository, this.type) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchPayments(
        PaymentsArgs(
          by: PaymentsBy.store,
          mode: FetchMode.full,
          type: type,
        ),
      ),
      parser: (r) {
        final result = Payments$Query.fromJson(r).payments;
        return ResourceListData(items: result);
      },
    );
  }
}

class PaymentsListCubit extends ParentPaymentsListCubit {
  PaymentsListCubit(PaymentRepository repository)
      : super(
          repository,
          PaymentType.order,
        );
}

class ExpensesListCubit extends ParentPaymentsListCubit {
  ExpensesListCubit(PaymentRepository repository)
      : super(
          repository,
          PaymentType.expense,
        );
}

