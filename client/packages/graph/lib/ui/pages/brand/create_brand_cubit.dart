import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/brand_repository.dart';

class CreateBrandCubit extends ResourceCubit<CreateBrand$Mutation$Brand> {
  CreateBrandCubit(this._repository) : super();
  final BrandRepository _repository;

  create(BrandInput input) {
    super.execute(
      executor: () => _repository.createBrand(input),
      parser: (r) {
        return CreateBrand$Mutation.fromJson(r).createBrand;
      },
    );
  }

  edit(EditBrandArguments arguments) {
    super.execute(
      executor: () => _repository.editBrand(arguments),
      parser: (r) {
        final result = EditBrand$Mutation.fromJson(r).editBrand;
        return CreateBrand$Mutation$Brand.fromJson(result.toJson());
      },
    );
  }
}
