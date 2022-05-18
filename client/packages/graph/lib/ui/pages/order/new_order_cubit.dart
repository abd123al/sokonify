import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class NewOrderItem {
  NewOrderItem({
    required this.quantity,
    required this.item,
    this.error,
  });

  final int quantity;
  final Items$Query$Item item;

  /// Lets say required quantity exceeds stock here is where we set that error
  final String? error;

  String get price {
    return "22";
  }

  bool get hasError {
    return error != null;
  }

  NewOrderItem copyWith({
    int? quantity,
    Items$Query$Item? item,
    String? error,
  }) {
    return NewOrderItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      error: error ?? this.error,
    );
  }
}

//todo allow user to create many orders simulations
//mfano ana anajaza order yangu na ya mwinginr
class NewOrder {
  NewOrder({
    required this.items,
  });

  final List<NewOrderItem> items;

  String get totalPrice {
    final arr = items.map((e) => e.price).toList();
    return arr[0];
  }

  NewOrder add({
    required NewOrderItem item,
  }) {
    return NewOrder(
      items: [...items, item],
    );
  }

  NewOrder edit({
    required NewOrderItem item,
    required int index,
  }) {
    List<NewOrderItem> copy = items;
    copy[index] = item;

    return NewOrder(
      items: copy,
    );
  }

  NewOrder empty() {
    return NewOrder(
      items: [],
    );
  }

// NewOrder delete({
//   required int index,
// }) {
//   return NewOrder(
//     items: [...items, item],
//   );
// }
}

class NewOrderCubit extends Cubit<NewOrder> {
  NewOrderCubit() : super(NewOrder(items: []).empty());

  reset() {
    emit(NewOrder(items: []).empty());
  }

  /// todo return error for duplicated items
  /// todo add it to the top
  /// todo add new items at the bottom and push that thing at the top
  addItem(Items$Query$Item item) {
    emit(
      state.add(
        item: NewOrderItem(
          quantity: 0,
          item: item,
        ),
      ),
    );
  }

  deleteItem() {}

  editQuantity(int index, int quantity) {
    final item = state.items[index];

    emit(
      state.edit(
        item: item.copyWith(
          quantity: quantity,
        ),
        index: index,
      ),
    );
  }
}
