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
    final color = payment.type == PaymentType.order
        ? Theme.of(context).primaryColorDark
        : Colors.red;

    return Card(
      child: ListTile(
        title: Text(
          payment.name,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${payment.createdAt}",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        trailing: Text(
          formatCurrency(payment.amount),
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
              ),
        ),
      ),
    );
  }
}
