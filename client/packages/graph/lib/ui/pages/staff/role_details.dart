import 'package:flutter/material.dart';

import '../../../nav/nav.dart';
import '../category/category_page.dart';

class RoleDetails extends StatelessWidget {
  const RoleDetails({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CategoryWidget(id: id),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => redirectTo(
          context,
          "${Routes.editCategory}/$id",
          replace: true,
        ),
        tooltip: 'Edit',
        icon: const Icon(Icons.edit),
        label: const Text("Edit"),
      ),
    );
  }
}
