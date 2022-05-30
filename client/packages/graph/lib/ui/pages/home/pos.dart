import 'package:flutter/material.dart';

import '../payment/payments_list.dart';
import 'stats/simple_stats.dart';

class POS extends StatelessWidget {
  const POS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          SimpleStats(),
          PaymentsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //todo here we just open window for single item
        },
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        label: const Text("Track Sales"),
      ),
    );
  }
}
