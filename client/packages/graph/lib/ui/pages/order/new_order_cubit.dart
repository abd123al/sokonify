import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../helpers/currency_formatter.dart';

class NewOrderItem extends Equatable {
  const NewOrderItem({
    required this.quantity,
    required this.item,
    this.customSellingPrice,
  });

  final int quantity;
  final Items$Query$Item item;
  final String? customSellingPrice;

  String get subTotal {
    final sub = Decimal.parse(customSellingPrice ?? item.sellingPrice) *
        Decimal.fromInt(quantity);

    return formatCurrency(sub.toString());
  }

  NewOrderItem copyWith({
    int? quantity,
    Items$Query$Item? item,
    String? error,
  }) {
    return NewOrderItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [item, quantity, customSellingPrice];
}

class NewOrder extends Equatable {
  const NewOrder({
    required this.items,
    this.customer,
    this.time,
    this.error,
  });

  final List<NewOrderItem> items;
  final Customers$Query$Customer? customer;
  final int? time;

  /// Lets say required quantity exceeds stock here is where we set that error
  final String? error;

  bool get hasError {
    return error != null;
  }

  NewOrder copyWith({
    List<NewOrderItem>? items,
    Customers$Query$Customer? customer,
    String? error,
  }) {
    return NewOrder(
      items: items ?? this.items,
      customer: customer ?? this.customer,
      time: DateTime.now().microsecondsSinceEpoch,
      error: error,
    );
  }

  String get totalPrice {
    return calculateTotal(
      items.map(
        (e) => TotalPriceArgs(
          price: e.customSellingPrice ?? e.item.sellingPrice,
          quantity: e.quantity,
        ),
      ),
    );
  }

  NewOrder addItem({
    required NewOrderItem obj,
  }) {
    if (items.map((e) => e.item.id).contains(obj.item.id)) {
      return copyWith(
        error: "${obj.item.product.name} has already been added.",
      );
    } else {
      if (obj.quantity <= obj.item.quantity) {
        return copyWith(
          items: [obj, ...items],
        );
      } else {
        return copyWith(
          error: "there only "
              "${obj.item.quantity} ${obj.item.unit.name} "
              "of ${obj.item.product.name}",
        );
      }
    }
  }

  NewOrder addCustomer({
    required Customers$Query$Customer? customer,
  }) {
    return copyWith(
      customer: customer,
    );
  }

  NewOrder edit({
    required NewOrderItem item,
    required int index,
  }) {
    List<NewOrderItem> copy = items;
    copy[index] = item;

    return copyWith(
      items: copy,
    );
  }

  NewOrder empty() {
    return const NewOrder(
      items: [],
    );
  }

  NewOrder delete({
    required int index,
  }) {
    List<NewOrderItem> copy = items;
    copy.remove(items[index]);

    return copyWith(
      items: copy,
    );
  }

  @override
  List<Object?> get props => [
        items,
        customer,
        time,
        error,
      ];
}

class NewOrderCubit extends Cubit<NewOrder> {
  NewOrderCubit() : super(const NewOrder(items: []).empty());

  reset() {
    emit(const NewOrder(items: []).empty());
  }

  /// todo return error for duplicated items
  /// todo add it to the top
  /// todo add new items at the bottom and push that thing at the top
  addItem(Items$Query$Item item, int quantity) {
    emit(
      state.addItem(
        obj: NewOrderItem(
          quantity: quantity,
          item: item,
        ),
      ),
    );
  }

  deleteItem(int index) {
    emit(
      state.delete(index: index),
    );
  }

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

  changeCustomer(Customers$Query$Customer? customer) {
    emit(
      state.addCustomer(
        customer: customer,
      ),
    );
  }
}
