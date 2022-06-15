import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/repositories.dart';

class CreateProductCubit extends ResourceCubit<CreateProduct$Mutation$Product> {
  CreateProductCubit(this._repository) : super();
  final ProductRepository _repository;

  create(ProductInput input) {
    super.execute(
      executor: () => _repository.createProduct(input),
      parser: (r) {
        return CreateProduct$Mutation.fromJson(r).createProduct;
      },
    );
  }

  edit(int id, ProductInput input) {
    super.execute(
      executor: () => _repository.editProduct(input, id),
      parser: (r) {
        final result = EditProduct$Mutation.fromJson(r).editProduct;
        return CreateProduct$Mutation$Product.fromJson(result.toJson());
      },
    );
  }
}
