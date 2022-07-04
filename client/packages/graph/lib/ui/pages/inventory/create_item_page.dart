import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'item_form.dart';

class CreateItemPage extends StatelessWidget {
  const CreateItemPage({
    Key? key,
    required this.pricing,
  }) : super(key: key);

  final Categories$Query$Category pricing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Stock"),
      ),
      body: ItemForm(
        item: null,
        id: null,
        pricing: pricing,
      ),
    );
  }
}