import 'package:flutter/material.dart';

import 'unit_form.dart';

class CreateUnitPage extends StatelessWidget {
  const CreateUnitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Unit"),
      ),
      body: const UnitForm(
        brand: null,
        id: null,
      ),
    );
  }
}
