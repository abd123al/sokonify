import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../helpers/currency_formatter.dart';

class NewOrderItem {
  NewOrderItem({
    required this.quantity,
    required this.item,
    this.error,
    this.customSellingPrice,
  });

  final int quantity;
  final Items$Query$Item item;
  final String? customSellingPrice;

  /// Lets say required quantity exceeds stock here is where we set that error
  final String? error;

  String get subTotal {
    final sub = Decimal.parse(customSellingPrice ?? item.sellingPrice) *
        Decimal.fromInt(quantity);

    return formatCurrency(sub.toString());
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
    final arr = items.map((e) {
      final subTotal =
          Decimal.parse(e.customSellingPrice ?? e.item.sellingPrice) *
              Decimal.fromInt(e.quantity);
      return subTotal;
    }).toList();

    var sum = Decimal.parse("0.00");

    for (var i = 0; i < arr.length; i++) {
      sum += arr[i];
    }

    return formatCurrency(sum.toString());
  }

  NewOrder add({
    required NewOrderItem item,
  }) {
    return NewOrder(
      items: [item, ...items],
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
  addItem(Items$Query$Item item, int quantity) {
    emit(
      state.add(
        item: NewOrderItem(
          quantity: quantity,
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
