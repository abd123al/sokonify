import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/inventory/prices_cubit.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'item_form.dart';
import 'item_wrapper.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Item"),
      ),
      body: ItemWrapper(
        id: id,
        builder: (context, item) {
          return BlocProvider(
            create: (context) {
              final prices = item.prices
                      .map((e) => Price(
                            amount: e.amount,
                            category: Categories$Query$Category.fromJson(
                                e.category.toJson()),
                          ))
                      .toList();

              return EditPriceCubit(NewPrice(prices: prices));
            },
            child: ItemForm<EditPriceCubit>(
              item: item,
              id: id,
            ),
          );
        },
      ),
    );
  }
}
