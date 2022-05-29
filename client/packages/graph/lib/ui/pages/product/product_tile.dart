import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Products$Query$Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(
        builder: (context) {
          return Card(
            elevation: 16,
            child: ListTile(
              title: Text(
                product.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          );
        },
      ),
    );
  }
}
