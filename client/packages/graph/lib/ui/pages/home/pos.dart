import 'package:flutter/material.dart';

import '../../../nav/nav.dart';
import '../payment/payments_list.dart';
import '../payment/payments_list_cubit.dart';
import 'stats/simple_stats.dart';

class POS extends StatelessWidget {
  const POS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const PaymentsList<PaymentsListCubit>(
        topper: SimpleStats(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => redirectTo(context, Routes.createSales),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        label: const Text("Track Sales"),
      ),

      // Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton.extended(
      //       onPressed: () => redirectTo(context, Routes.createCustomPayment),
      //       icon: const Icon(Icons.payment),
      //       backgroundColor: Colors.blueGrey,
      //       label: const Text("Add Payment"),
      //     ),
      //     const SizedBox(height: 16,width: 0),
      //     FloatingActionButton.extended(
      //       onPressed: () => redirectTo(context, Routes.createSales),
      //       icon: const Icon(Icons.add),
      //       backgroundColor: Colors.blue,
      //       label: const Text("Track Sales  "),
      //     ),
      //   ],
      // ),
    );
  }
}
