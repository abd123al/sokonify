import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/repositories.dart';

class CreateProductCubit extends ResourceCubit<ProductPartsMixin> {
  CreateProductCubit(this._repository) : super();
  final ProductRepository _repository;

  submit(ProductInput input) {
    super.execute(
      executor: () => _repository.createProduct(input),
      parser: (r) {
        return CreateProduct$Mutation.fromJson(r).createProduct;
      },
    );
  }
}
