import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';

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
        return Card(
          child: ListTile(
            tileColor: color,
            title: Text(
              brand.name,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              redirectTo(
                context,
                "${Routes.brand}/${brand.id}",
                args: brand.name,
              );
            },
          ),
        );
      },
    );
  }
}
