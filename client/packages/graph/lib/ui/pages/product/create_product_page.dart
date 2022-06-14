import 'package:flutter/material.dart';

import 'product_form.dart';

class CreateProductPage extends StatelessWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Product"),
      ),
      body: const ProductForm(),
    );
  }
}
