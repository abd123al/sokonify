import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../repositories/repositories.dart';

class StoreBuilderCubit extends ResourceCubit<CurrentStore$Query$Store?> {
  final StoreRepository _repository;

  StoreBuilderCubit(this._repository) : super();

  fetch() {
    super.execute(
      executor: () => _repository.fetchCurrentStore(),
      parser: (r) => CurrentStore$Query.fromJson(r).currentStore,
    );
  }
}
