import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class Price extends Equatable {
  const Price({
    required this.amount,
    required this.category,
  });

  final String amount;
  final Categories$Query$Category category;

  Price copyWith({
    String? amount,
    Categories$Query$Category? category,
    String? error,
  }) {
    return Price(
      category: category ?? this.category,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [category, amount];
}

class NewPrice extends Equatable {
  const NewPrice({
    required this.prices,
    this.time,
    this.error,
  });

  final List<Price> prices;
  final int? time;

  /// Lets say required quantity exceeds stock here is where we set that error
  final String? error;

  bool get hasError {
    return error != null;
  }

  NewPrice copyWith({
    List<Price>? prices,
    String? error,
  }) {
    return NewPrice(
      prices: prices ?? this.prices,
      time: DateTime.now().microsecondsSinceEpoch,
      error: error,
    );
  }

  NewPrice addItem({
    required Price obj,
  }) {
    if (prices.map((e) => e.category.id).contains(obj.category.id)) {
      return copyWith(
        error: "${obj.category.name} has already been added.",
      );
    } else {
      return copyWith(
        prices: [obj, ...prices],
      );
    }
  }

  NewPrice edit({
    required Price item,
    required int index,
  }) {
    List<Price> copy = prices;
    copy[index] = item;

    return copyWith(
      prices: copy,
    );
  }

  NewPrice empty() {
    return const NewPrice(
      prices: [],
    );
  }

  NewPrice delete({
    required int index,
  }) {
    List<Price> copy = prices;
    copy.remove(prices[index]);

    return copyWith(
      prices: copy,
    );
  }

  @override
  List<Object?> get props => [
        prices,
        time,
        error,
      ];
}

class PricingCubit extends Cubit<NewPrice> {
  PricingCubit(NewPrice initialState) : super(initialState);

  reset() {
    emit(const NewPrice(prices: []).empty());
  }

  addItem(Categories$Query$Category item, String quantity) {
    emit(
      state.addItem(
        obj: Price(
          amount: quantity,
          category: item,
        ),
      ),
    );
  }

  deleteItem(int index) {
    emit(
      state.delete(index: index),
    );
  }

  editQuantity(int index, String quantity) {
    final item = state.prices[index];

    emit(
      state.edit(
        item: item.copyWith(
          amount: quantity,
        ),
        index: index,
      ),
    );
  }
}

class NewPriceCubit extends PricingCubit {
  NewPriceCubit() : super(const NewPrice(prices: []).empty());
}

class EditPriceCubit extends PricingCubit {
  EditPriceCubit(NewPrice initial) : super(initial);
}
