import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/fab.dart';
import '../customer/customers_list.dart';

class Customers extends StatelessWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CustomersList(),
      floatingActionButton: Fab(
        route: Routes.createCustomer,
        title: "Register Customer",
        permission: PermissionType.createCustomer,
      ),
    );
  }
}