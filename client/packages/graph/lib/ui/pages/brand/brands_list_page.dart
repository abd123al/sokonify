import 'package:flutter/material.dart';
import 'package:graph/gql/generated/graphql_api.dart';

import '../../../nav/nav.dart';
import '../../widgets/fab.dart';
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
      floatingActionButton: Fab(
        route: Routes.createBrand,
        title: "Create Brand",
        permission: PermissionType.createBrand,
      ),
    );
  }
}
