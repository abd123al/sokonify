import 'package:flutter/material.dart';

import 'product_form.dart';
import 'product_wrapper.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: ProductWrapper(
        id: id,
        builder: (context, product) {
          return ProductForm(
            product: product,
            id: id,
          );
        },
      ),
    );
  }
}
