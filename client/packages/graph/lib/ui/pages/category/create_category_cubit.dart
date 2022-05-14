import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/category_repository.dart';

class CreateCategoryCubit extends ResourceCubit<CreateCategory$Mutation$Category> {
  CreateCategoryCubit(this._repository) : super();
  final CategoryRepository _repository;

  submit(CategoryInput input) {
    super.execute(
      executor: () => _repository.createCategory(input),
      parser: (r) {
        return CreateCategory$Mutation.fromJson(r).createCategory;
      },
    );
  }
}
