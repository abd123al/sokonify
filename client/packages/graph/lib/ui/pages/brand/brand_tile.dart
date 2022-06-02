import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class BrandTile extends StatelessWidget {
  const BrandTile({
    Key? key,
    required this.brand,
    this.color,
  }) : super(key: key);

  final Brands$Query$Brand brand;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ListTile(
          tileColor: color,
          title: Text(
            brand.name,
            overflow: TextOverflow.ellipsis,
          ),
          dense: true,
        );
      },
    );
  }
}
