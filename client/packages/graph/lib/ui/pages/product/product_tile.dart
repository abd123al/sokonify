import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/redirect_to.dart';
import '../../../nav/routes.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    Key? key,
    required this.product,
    this.color,
  }) : super(key: key);

  final Products$Query$Product product;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 16,
      child: ListTile(
        title: Text(
          product.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        onTap: () {
          redirectTo(context, "${Routes.product}/${product.id}");
        },
      ),
    );
  }
}
