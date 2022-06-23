import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/repositories.dart';

class CreateCustomerCubit extends ResourceCubit<CreateCustomer$Mutation$Customer> {
  CreateCustomerCubit(this._repository) : super();
  final CustomerRepository _repository;

  create(CustomerInput input) {
    super.execute(
      executor: () => _repository.createCustomer(input),
      parser: (r) {
        return CreateCustomer$Mutation.fromJson(r).createCustomer;
      },
    );
  }

  edit(EditCustomerArguments arguments) {
    super.execute(
      executor: () => _repository.editCustomer(arguments),
      parser: (r) {
        final result = EditCustomer$Mutation.fromJson(r).editCustomer;
        return CreateCustomer$Mutation$Customer.fromJson(result.toJson());
      },
    );
  }
}
