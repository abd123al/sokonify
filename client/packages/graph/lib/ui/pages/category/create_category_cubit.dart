import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/category_repository.dart';

class CreateCategoryCubit
    extends ResourceCubit<CreateCategory$Mutation$Category> {
  CreateCategoryCubit(this._repository) : super();
  final CategoryRepository _repository;

  create(CategoryInput input) {
    super.execute(
      executor: () => _repository.createCategory(input),
      parser: (r) {
        return CreateCategory$Mutation.fromJson(r).createCategory;
      },
    );
  }

  edit(int id, CategoryInput input) {
    super.execute(
      executor: () => _repository.editCategory(id, input),
      parser: (r) {
        final result = EditCategory$Mutation.fromJson(r).editCategory;
        return CreateCategory$Mutation$Category.fromJson(result.toJson());
      },
    );
  }
}
