import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../helpers/currency_formatter.dart';

class NewOrderItem extends Equatable {
  const NewOrderItem({
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

  @override
  List<Object?> get props => [item, quantity, customSellingPrice, error];
}

class NewOrder extends Equatable {
  const NewOrder({
    required this.items,
    this.customer,
  });

  final List<NewOrderItem> items;
  final Customers$Query$Customer? customer;

  NewOrder copyWith({
    List<NewOrderItem>? items,
    Customers$Query$Customer? customer,
  }) {
    return NewOrder(
      items: items ?? this.items,
      customer: customer ?? this.customer,
    );
  }

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

  NewOrder addItem({
    required NewOrderItem item,
  }) {
    return copyWith(
      items: [item, ...items],
    );
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
  List<Object?> get props => [items, customer];
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
        item: NewOrderItem(
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
