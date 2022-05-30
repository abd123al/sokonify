import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/payment_repository.dart';

class PaymentsListCubit extends ResourceListCubit<Payments$Query$Payment> {
  final PaymentRepository _repository;

  PaymentsListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchPayments(
        PaymentsArgs(
          by: PaymentsBy.store,
          mode: FetchMode.full,
        ),
      ),
      parser: (r) {
        final result = Payments$Query.fromJson(r).payments;
        return ResourceListData(items: result);
      },
    );
  }
}
