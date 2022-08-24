import 'package:graph/gql/generated/graphql_api.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BrandRepository {
  final GraphQLClient client;

  BrandRepository(this.client);

  createBrand(BrandInput input) {
    final options = MutationOptions(
      document: CREATE_BRAND_MUTATION_DOCUMENT,
      variables: CreateBrandArguments(input: input).toJson(),
    );

    return client.mutate(options);
  }

  fetchBrands() {
    final options = QueryOptions(
      document: BRANDS_QUERY_DOCUMENT,
      variables: BrandsArguments(args: BrandsArgs()).toJson(),
    );

    return client.query(options);
  }

  fetchBrand(int id) {
    final options = QueryOptions(
        document: BRAND_QUERY_DOCUMENT,
        variables: BrandArguments(id: id).toJson());

    return client.query(options);
  }
}
