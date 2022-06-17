import 'package:flutter/material.dart';

import 'store_form.dart';
import 'store_wrapper.dart';

class EditStorePage extends StatelessWidget {
  const EditStorePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Facility"),
      ),
      body: StoreWrapper(
        builder: (context, product) {
          return StoreForm(
            store: product,
          );
        },
      ),
    );
  }
}
