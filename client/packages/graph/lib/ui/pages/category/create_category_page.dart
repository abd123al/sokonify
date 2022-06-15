import 'package:flutter/material.dart';

import 'category_form.dart';

class CreateCategoryPage extends StatelessWidget {
  const CreateCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Category"),
      ),
      body: const CategoryForm(
        category: null,
        id: null,
      ),
    );
  }
}
