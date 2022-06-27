import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/helpers/helpers.dart';
import 'package:graph/ui/widgets/widgets.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/payment_repository.dart';
import '../order/order_item_tile.dart';
import 'payment_page_cubit.dart';

/// There is no need at all to edit posted order.
/// todo add print receipt/invoice here too.
class PaymentPage extends StatelessWidget {
  const PaymentPage({
    Key? key,
    required this.id,
    required this.word,
  }) : super(key: key);

  final int id;
  final String word;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$word #$id"),
      ),
      body: BlocProvider(
        create: (context) {
          return PaymentPageCubit(
            RepositoryProvider.of<PaymentRepository>(context),
          );
        },
        child: _build(),
      ),
    );
  }

  Widget _build() {
    return QueryBuilder<Payment$Query$Payment, PaymentPageCubit>(
      retry: (cubit) => cubit.fetch(id),
      initializer: (cubit) => cubit.fetch(id),
      builder: (context, data, _) {
        return ListView(
          children: [
            ShortDetailTile(
                subtitle: "Amount", value: formatCurrency(data.amount)),
            if (data.expense != null)
              ShortDetailTile(
                  subtitle: "Expenses Category", value: data.expense?.name),
            ShortDetailTile(subtitle: "Description", value: data.description),
            ShortDetailTile(subtitle: "Submitted By", value: data.staff.name),
            ShortDetailTile(
                subtitle: "Submitted on", value: data.createdAt.toString()),
            if (data.orderItems != null) const WordDivider(text: 'Items'),
            if (data.orderItems != null)
              Builder(
                builder: (context) {
                  final brands =
                      ResourceListData<Payment$Query$Payment$OrderItem>(
                    items: data.orderItems,
                  );

                  return HighList<Payment$Query$Payment$OrderItem>(
                    items: brands,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    emptyWord: "No brands found",
                    builder: (context, item, color) {
                      return OrderItemTile(
                        orderItem: item,
                        color: color,
                      );
                    },
                  );
                },
              )
          ],
        );
      },
    );
  }
}
