import 'package:blocitory/blocitory.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';
import '../../../repositories/store_repository.dart';

class ConvertStocksCubit extends ResourceCubit<List<ConvertStock$Mutation$Item>> {
  ConvertStocksCubit(this._repository) : super();
  final ItemRepository _repository;

  submit(ConvertStockInput input) {
    super.execute(
      executor: () => _repository.convertStock(input),
      parser: (r) {
        return ConvertStock$Mutation.fromJson(r).convertStock;
      },
    );
  }
}
