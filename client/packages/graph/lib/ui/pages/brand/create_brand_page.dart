import 'package:flutter/material.dart';

import 'brand_form.dart';

class CreateBrandPage extends StatelessWidget {
  const CreateBrandPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Brand"),
      ),
      body: const BrandForm(
        id: null,
        brand: null,
      ),
    );
  }
}
