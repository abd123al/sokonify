import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';
import 'payment_tile.dart';
import 'payments_list_cubit.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({
    Key? key,
    this.type = PaymentType.order,
    required this.topper,
  }) : super(key: key);

  final PaymentType type;
  final Widget topper;

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Payments$Query$Payment>,
        PaymentsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        word() {
          if (type == PaymentType.order) {
            return "Payments";
          }
          return "Expenses";
        }

        final payments = data.items.where((e) => e.type == type).toList();

        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            topper,
            Topper(
              label: "Today ${word()}",
              onPressed: () {
                redirectTo(
                  context,
                  "${Routes.payments}/${word()}",
                  args: type,
                );
              },
            ),
            HighList<Payments$Query$Payment>(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              emptyWord: "No recent payments",
              builder: (context, store, color) {
                return PaymentTile(
                  payment: store,
                  color: color,
                );
              },
              items: data.copyWith(
                items: payments,
              ),
            ),
          ],
        );
      },
    );
  }
}
