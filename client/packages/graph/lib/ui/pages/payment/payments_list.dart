import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/widgets.dart';
import 'payment_tile.dart';
import 'payments_list_cubit.dart';

//todo add eksipensi order filter and use it in two tabs
class PaymentsList extends StatelessWidget {
  const PaymentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Payments$Query$Payment>,
        PaymentsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        return Column(
          children: [
            const Topper(
              label: "Today Payments",
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final p = data.items[index];
                return PaymentTile(payment: p);
              },
              itemCount: data.items.length,
            ),
          ],
        );
      },
    );
  }
}
