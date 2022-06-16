import 'package:flutter/material.dart';

import 'item_form.dart';
import 'item_wrapper.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Item"),
      ),
      body: ItemWrapper(
        id: id,
        builder: (context, item) {
          return ItemForm(
            item: item,
            id: id,
          );
        },
      ),
    );
  }
}
