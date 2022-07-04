import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/customer_repository.dart';
import '../../../repositories/order_repository.dart';

class CustomerPageCubit extends ResourceCubit<Customer$Query$Customer> {
  final CustomerRepository _repository;

  CustomerPageCubit(this._repository) : super();

  fetch(int id) {
    super.execute(
      executor: () => _repository.fetchCustomer(id),
      parser: (r) => Customer$Query.fromJson(r).customer,
    );
  }
}
