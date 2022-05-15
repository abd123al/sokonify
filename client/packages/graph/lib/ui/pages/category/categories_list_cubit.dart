import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/category_repository.dart';

class CategoriesListCubit extends ResourceListCubit<Categories$Query$Category> {
  final CategoryRepository _repository;

  CategoriesListCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchCategories(),
      parser: (r) {
        final result = Categories$Query.fromJson(r).categories;
        return ResourceListData(items: result);
      },
    );
  }
}
