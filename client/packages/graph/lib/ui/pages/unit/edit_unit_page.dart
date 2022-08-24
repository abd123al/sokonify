import 'package:flutter/material.dart';

import 'unit_form.dart';
import 'unit_wrapper.dart';

class EditUnitPage extends StatelessWidget {
  const EditUnitPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Unit"),
      ),
      body: UnitWrapper(
        id: id,
        builder: (context, brand) {
          return UnitForm(
            brand: brand,
            id: id,
          );
        },
      ),
    );
  }
}
