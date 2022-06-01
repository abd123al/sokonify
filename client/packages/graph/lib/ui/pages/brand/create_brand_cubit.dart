import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/brand_repository.dart';

class CreateBrandCubit extends ResourceCubit<CreateBrand$Mutation$Brand> {
  CreateBrandCubit(this._repository) : super();
  final BrandRepository _repository;

  submit(BrandInput input) {
    super.execute(
      executor: () => _repository.createBrand(input),
      parser: (r) {
        return CreateBrand$Mutation.fromJson(r).createBrand;
      },
    );
  }
}
