import 'package:flutter/material.dart';
import 'package:graph/nav/redirect_to.dart';
import 'package:graph/ui/helpers/extensions.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/routes.dart';
import '../../widgets/widgets.dart';
import '../stats/sub_stats.dart';
import 'category_wrapper.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(
        label: "Category",
        onPressed: () {
          redirectTo(
            context,
            "${Routes.editCategory}/$id",
            replace: true,
          );
        },
      ),
      body: CategoryWidget(
        id: id,
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return CategoryWrapper(
      id: id,
      builder: (context, data) {
        return DetailsList(
          children: [
            Builder(builder: (context) {
              StatsFilter? filter;

              if (data.type == CategoryType.category) {
                filter = StatsFilter.productsCategory;
              } else if (data.type == CategoryType.subcategory) {
                filter = StatsFilter.stocksCategory;
              } else if (data.type == CategoryType.pricing) {
                filter = StatsFilter.pricing;
              }

              if (filter != null) {
                return SubStats(filter: filter, id: id,
                  name: data.name,);
              }

              return const SizedBox.shrink();
            }),
            ShortDetailTile(
              subtitle: "Category Name",
              value: data.name,
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
