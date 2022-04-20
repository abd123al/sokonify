import 'package:blocitory/blocitory.dart';

import '../../gql/generated/graphql_api.graphql.dart';
import '../../repositories/store_repository.dart';

class CreateStoreCubit extends ResourceCubit<CreateStore$Mutation$Store> {
  CreateStoreCubit(this._repository) : super();
  final StoreRepository _repository;

  submit(StoreInput input) {
    super.execute(
      executor: () => _repository.createStore(input),
      parser: (r) {
        return CreateStore$Mutation.fromJson(r).createStore;
      },
    );
  }
}
