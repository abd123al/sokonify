import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.dart';
import 'category_form.dart';

class CreateCategoryPage extends StatelessWidget {
  const CreateCategoryPage({
    Key? key,
    required this.type,
  }) : super(key: key);

  final CategoryType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Category"),
      ),
      body: CategoryForm(
        category: null,
        id: null,
        type: type,
      ),
    );
  }
}
