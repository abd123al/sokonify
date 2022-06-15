import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProductRepository {
  final GraphQLClient client;

  ProductRepository( this.client);

  editProduct(ProductInput input,int id) {
    final options = MutationOptions(
      document: EDIT_PRODUCT_MUTATION_DOCUMENT,
      variables: EditProductArguments(input: input, id: id).toJson(),
    );

    return client.mutate(options);
  }


  createProduct(ProductInput input) {
    final options = MutationOptions(
      document: CREATE_PRODUCT_MUTATION_DOCUMENT,
      variables: CreateProductArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchProducts(ProductsArgs args) {
    final options = QueryOptions(
      document: PRODUCTS_QUERY_DOCUMENT,
      variables: ProductsArguments(args: args).toJson(),
    );

    return client.query(options);
  }

  fetchProduct(int id ) {
    final options = QueryOptions(
      document: PRODUCT_QUERY_DOCUMENT,
      variables: ProductArguments(id: id).toJson(),
    );

    return client.query(options);
  }
}
