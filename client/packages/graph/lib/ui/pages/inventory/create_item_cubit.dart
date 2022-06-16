import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';
import '../../../repositories/store_repository.dart';

class CreateItemCubit extends ResourceCubit<CreateItem$Mutation$Item> {
  CreateItemCubit(this._repository) : super();
  final ItemRepository _repository;

  create(ItemInput input) {
    super.execute(
      executor: () => _repository.createItem(input),
      parser: (r) {
        return CreateItem$Mutation.fromJson(r).createItem;
      },
    );
  }


  edit(int id, ItemInput input) {
    super.execute(
      executor: () => _repository.editItem(id,input),
      parser: (r) {
        final result = EditItem$Mutation.fromJson(r).editItem;
        return CreateItem$Mutation$Item.fromJson(result.toJson());
      },
    );
  }
}
