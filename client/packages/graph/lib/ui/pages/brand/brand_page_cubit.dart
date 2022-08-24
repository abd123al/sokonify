import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/brand_repository.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/product_repository.dart';

class BrandCubit extends ResourceCubit<Brand$Query$Brand> {
  final BrandRepository _repository;

  BrandCubit(this._repository) : super();

  fetch(int id) {
    super.execute(
      executor: () => _repository.fetchBrand(id),
      parser: (r) => Brand$Query.fromJson(r).brand,
    );
  }
}
