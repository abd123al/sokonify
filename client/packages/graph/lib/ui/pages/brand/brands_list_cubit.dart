import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/repositories.dart';

class BrandsListCubit extends ResourceListCubit<Brands$Query$Brand> {
  final BrandRepository _repository;

  BrandsListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchBrands(),
      parser: (r) {
        final result = Brands$Query.fromJson(r).brands;
        return ResourceListData(items: result);
      },
    );
  }
}
