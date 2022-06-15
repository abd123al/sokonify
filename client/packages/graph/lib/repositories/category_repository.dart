import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CategoryRepository {
  final GraphQLClient client;

  CategoryRepository(this.client);

  createCategory(CategoryInput input) {
    final options = MutationOptions(
      document: CREATE_CATEGORY_MUTATION_DOCUMENT,
      variables: CreateCategoryArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  editCategory(int id, CategoryInput input) {
    final options = MutationOptions(
      document: EDIT_CATEGORY_MUTATION_DOCUMENT,
      variables: EditCategoryArguments(id: id, input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchCategories() {
    final options = QueryOptions(
      document: CategoriesQuery().document,
    );

    return client.query(options);
  }

  fetchCategory(int id) {
    final options = QueryOptions(
        document: CATEGORY_QUERY_DOCUMENT,
        variables: CategoryArguments(id: id).toJson());

    return client.query(options);
  }
}
