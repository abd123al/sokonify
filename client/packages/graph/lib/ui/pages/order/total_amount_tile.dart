import 'package:flutter/material.dart';


class TotalAmountTile extends StatelessWidget {
  const TotalAmountTile({
    Key? key,
    required this.amount,
  }) : super(key: key);

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      child: ListTile(
        title: Text(
          "Total Amount",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: Text(
          amount,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
