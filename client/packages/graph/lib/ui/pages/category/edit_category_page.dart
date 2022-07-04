import 'package:flutter/material.dart';

import 'category_form.dart';
import 'category_wrapper.dart';

class EditCategoryPage extends StatelessWidget {
  const EditCategoryPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
      ),
      body: CategoryWrapper(
        id: id,
        builder: (context, category) {
          return CategoryForm(
            category: category,
            id: id,
            type: category.type,
          );
        },
      ),
    );
  }
}
