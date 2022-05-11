import 'package:flutter/material.dart';

import 'stats.dart';

class POS extends StatelessWidget {
  const POS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          SimpleStats(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.new_label),
        label: const Text("New Order"),
      ),
    );
  }
}
