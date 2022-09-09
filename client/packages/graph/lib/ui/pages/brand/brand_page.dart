import 'package:flutter/material.dart';
import 'package:graph/nav/redirect_to.dart';
import 'package:graph/ui/helpers/extensions.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/routes.dart';
import '../../widgets/widgets.dart';
import '../stats/sub_stats.dart';
import 'brand_wrapper.dart';

class BrandPage extends StatelessWidget {
  const BrandPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(
        label: "Brand",
        onPressed: () {
          redirectTo(
            context,
            "${Routes.editBrand}/$id",
            replace: true,
          );
        },
      ),
      body: BrandWidget(
        id: id,
      ),
    );
  }
}

class BrandWidget extends StatelessWidget {
  const BrandWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return BrandWrapper(
      id: id,
      builder: (context, data) {
        return DetailsList(
          children: [
            SubStats(
              filter: StatsFilter.brand,
              id: id,
              name: data.name,
            ),
            ShortDetailTile(
              subtitle: "Brand Name",
              value: data.name,
            ),
            ShortDetailTile(
              subtitle: "Product",
              value: data.product.name,
            ),
            ShortDetailTile(
              subtitle: "Description",
              value: data.description,
            ),
            ShortDetailTile(
              subtitle: "Created By",
              value: data.creator?.name,
            ),
            ShortDetailTile(
              subtitle: "Created on",
              value: data.createdAt.toTime().toString(),
            ),
          ],
        );
      },
    );
  }
}
