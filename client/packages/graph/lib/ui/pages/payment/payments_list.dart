import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/widgets.dart';
import 'payment_tile.dart';
import 'payments_list_cubit.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({
    Key? key,
    this.type = PaymentType.order,
  }) : super(key: key);

  final PaymentType type;

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
          shrinkWrap: true,
          children: [
            Topper(
              label: "Today ${word()}",
            ),
            ListView.builder(
              controller: ScrollController(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final p = payments[index];
                return PaymentTile(payment: p);
              },
              itemCount: payments.length,
            ),
          ],
        );
      },
    );
  }
}
