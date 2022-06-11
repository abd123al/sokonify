import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/payment_repository.dart';
import '../../../repositories/product_repository.dart';

class PaymentPageCubit extends ResourceCubit<Payment$Query$Payment> {
  final PaymentRepository _repository;

  PaymentPageCubit(this._repository) : super();

  fetch(int id) {
    super.execute(
      executor: () => _repository.fetchPayment(id),
      parser: (r) => Payment$Query.fromJson(r).payment,
    );
  }
}
