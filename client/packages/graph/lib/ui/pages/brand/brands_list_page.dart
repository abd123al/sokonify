import 'package:flutter/material.dart';
import 'package:graph/gql/generated/graphql_api.dart';

import '../../../nav/nav.dart';
import '../../widgets/permission_builder.dart';
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
      floatingActionButton: PermissionBuilder(
        type: PermissionType.createBrand,
        builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () => redirectTo(context, Routes.createBrand),
            tooltip: 'Add',
            icon: const Icon(Icons.add),
            label: const Text("New Brand"),
          );
        },
      ),
    );
  }
}
