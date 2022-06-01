import 'package:flutter/material.dart';

import '../../../nav/nav.dart';
import 'brands_list.dart';

class BrandsListPage extends StatelessWidget {
  const BrandsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brands"),
      ),
      body: const BrandsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => redirectTo(context, Routes.createBrand),
        tooltip: 'Add',
        icon: const Icon(Icons.add),
        label: const Text("New Brand"),
      ),
    );
  }
}
