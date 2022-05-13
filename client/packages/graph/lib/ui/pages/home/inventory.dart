import 'package:flutter/material.dart';

import '../../../nav/nav.dart';
import '../inventory/items_list.dart';

class Inventory extends StatelessWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ItemsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => redirectTo(context, Routes.createStore),
        tooltip: 'Add',
        icon: const Icon(Icons.add),
        label: const Text("New Item"),
      ),
    );
  }
}
