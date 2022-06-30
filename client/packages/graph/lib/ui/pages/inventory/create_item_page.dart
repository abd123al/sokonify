import 'package:flutter/material.dart';

import 'item_form.dart';

class CreateItemPage extends StatelessWidget {
  const CreateItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Stock"),
      ),
      body: const ItemForm(
        item: null,
        id: null,
      ),
    );
  }
}