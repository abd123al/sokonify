import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/product_repository.dart';

class ProductPageCubit extends ResourceCubit<Product$Query$Product> {
  final ProductRepository _repository;

  ProductPageCubit(this._repository) : super();

  fetch(int id) {
    super.execute(
      executor: () => _repository.fetchProduct(id),
      parser: (r) => Product$Query.fromJson(r).product,
    );
  }
}
