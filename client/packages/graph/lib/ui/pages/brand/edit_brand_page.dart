import 'package:flutter/material.dart';

import 'brand_form.dart';
import 'brand_wrapper.dart';

class EditBrandPage extends StatelessWidget {
  const EditBrandPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Brand"),
      ),
      body: BrandWrapper(
        id: id,
        builder: (context, brand) {
          return BrandForm(
            brand: brand,
            id: id,
          );
        },
      ),
    );
  }
}
