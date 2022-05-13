import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/product_repository.dart';

class ProductsListCubit
    extends ResourceCubit<ResourceListData<ProductPartsMixin>> {
  final ProductRepository _repository;

  ProductsListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchProducts(
        ProductsArgs(
          by: ProductsBy.store,
          value: 0,
        ),
      ),
      parser: (r) {
        final result = Products$Query.fromJson(r).products;
        return ResourceListData(items: result);
      },
    );
  }

  addProduct(ProductPartsMixin item) {
    final list = state.data?.items;
    list?.insert(0, item);

    super.update(state.data?.copyWith(
      items: list,
      addedItems: [item],
    ));
  }
}
