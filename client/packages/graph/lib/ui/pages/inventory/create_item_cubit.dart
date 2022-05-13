import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';
import '../../../repositories/store_repository.dart';

class CreateItemCubit extends ResourceCubit<ItemPartsMixin> {
  CreateItemCubit(this._repository) : super();
  final ItemRepository _repository;

  submit(ItemInput input) {
    super.execute(
      executor: () => _repository.createItem(input),
      parser: (r) {
        return CreateItem$Mutation.fromJson(r).createItem;
      },
    );
  }
}
