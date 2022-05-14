import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/category_repository.dart';

class CategoriesListCubit
    extends ResourceCubit<ResourceListData<Categories$Query$Category>> {
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

  addCategory(Categories$Query$Category cat) {
    final list = state.data?.items;
    list?.insert(0, cat);

    super.update(state.data?.copyWith(
      items: list,
      addedItems: [cat],
    ));
  }
}
