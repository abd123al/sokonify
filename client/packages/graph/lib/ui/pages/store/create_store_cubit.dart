import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/store_repository.dart';

class CreateStoreCubit extends ResourceCubit<CreateStore$Mutation$Store> {
  CreateStoreCubit(this._repository) : super();
  final StoreRepository _repository;

  create(StoreInput input) {
    super.execute(
      executor: () => _repository.createStore(input),
      parser: (r) {
        return CreateStore$Mutation.fromJson(r).createStore;
      },
    );
  }

  edit(int id, StoreInput input) {
    super.execute(
      executor: () => _repository.editStore(id, input),
      parser: (r) {
        final result = EditStore$Mutation.fromJson(r).editStore;
        return CreateStore$Mutation$Store.fromJson(result.toJson());
      },
    );
  }
}
