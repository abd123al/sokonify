import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/repositories.dart';

class CreateCustomerCubit extends ResourceCubit<CreateCustomer$Mutation$Customer> {
  CreateCustomerCubit(this._repository) : super();
  final CustomerRepository _repository;

  submit(CustomerInput input) {
    super.execute(
      executor: () => _repository.createCustomer(input),
      parser: (r) {
        return CreateCustomer$Mutation.fromJson(r).createCustomer;
      },
    );
  }
}
