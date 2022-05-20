import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/customer_repository.dart';

class CustomersListCubit extends ResourceListCubit<Customers$Query$Customer> {
  final CustomerRepository _repository;

  CustomersListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchCustomers(),
      parser: (r) {
        final result = Customers$Query.fromJson(r).customers;
        return ResourceListData(items: result);
      },
    );
  }
}
