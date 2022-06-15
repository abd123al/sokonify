import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/product_repository.dart';

class CategoryCubit extends ResourceCubit<Category$Query$Category> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super();

  fetch(int id) {
    super.execute(
      executor: () => _repository.fetchCategory(id),
      parser: (r) => Category$Query.fromJson(r).category,
    );
  }
}
