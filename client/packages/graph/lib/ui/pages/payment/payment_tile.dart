import 'package:flutter/material.dart';
import 'package:graph/ui/helpers/helpers.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class PaymentTile extends StatelessWidget {
  const PaymentTile({
    Key? key,
    required this.payment,
    this.currency = "TZS",
  }) : super(key: key);

  final Payments$Query$Payment payment;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(
        builder: (context) {
          return ListTile(
            title: Text(
              payment.amount,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "${payment.createdAt}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Text(
              formatCurrency(payment.amount),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        },
      ),
    );
  }
}
