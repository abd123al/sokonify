import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../helpers/currency_formatter.dart';
import '../inventory/item_tile.dart';

class NewOrderItem extends Equatable {
  const NewOrderItem({
    required this.pricingId,
    required this.quantity,
    required this.item,
    this.customSellingPrice,
  });

  final int quantity;
  final Items$Query$Item item;
  final String? customSellingPrice;
  final int pricingId;

  String get subTotal {
    final sub =
        Decimal.parse(customSellingPrice ?? ItemTile.price(item, pricingId)) *
            Decimal.fromInt(quantity);

    return formatCurrency(sub.toString());
  }

  NewOrderItem copyWith({
    int? quantity,
    int? pricingId,
    Items$Query$Item? item,
    String? error,
  }) {
    return NewOrderItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      pricingId: pricingId ?? this.pricingId,
    );
  }

  static NewOrderItem fromJson(Map<String, dynamic> json) {
    return NewOrderItem(
      quantity: json['quantity'] as int,
      item: Items$Query$Item.fromJson(json['item'] as Map<String, dynamic>),
      pricingId: json['pricingId'] as int,
      customSellingPrice: json['customSellingPrice'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'item': item.toJson(),
      'customSellingPrice': customSellingPrice,
      'pricingId': pricingId,
    };
  }

  @override
  List<Object?> get props => [item, quantity, customSellingPrice, pricingId];
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
          price: e.customSellingPrice ?? ItemTile.price(e.item, e.pricingId),
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

  static NewOrder? fromJson(Map<String, dynamic> json) {
    Customers$Query$Customer? customer;

    customer = Customers$Query$Customer.fromJson(json['customer']);

    final jsonItems = json['items'] as List<dynamic>?;

    final items = jsonItems
        ?.map(
          (e) => NewOrderItem.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    return NewOrder(
      customer: customer,
      items: items ?? [],
      time: json['time'] as int?,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic>? toJson() {
    final map = {
      'items': items.map((e) => e.toJson()).toList(),
      'customer': customer?.toJson(),
      'time': time,
      'error': error,
    };

    return map;
  }
}

class OrderCubit extends HydratedCubit<NewOrder> {
  OrderCubit(NewOrder initialState) : super(initialState);

  reset() {
    emit(const NewOrder(items: []).empty());
  }

  /// todo return error for duplicated items
  /// todo add it to the top
  /// todo add new items at the bottom and push that thing at the top
  addItem({
    required Items$Query$Item item,
    required int quantity,
    required int pricingId,
  }) {
    emit(
      state.addItem(
        obj: NewOrderItem(
          quantity: quantity,
          item: item,
          pricingId: pricingId,
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

  @override
  NewOrder? fromJson(Map<String, dynamic> json) {
    return NewOrder.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(NewOrder state) {
    return state.toJson();
  }
}

class NewOrderCubit extends OrderCubit {
  NewOrderCubit() : super(const NewOrder(items: []).empty());
}

class EditOrderCubit extends OrderCubit {
  EditOrderCubit(NewOrder initial) : super(initial);
}
