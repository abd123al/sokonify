import 'package:flutter/material.dart';
import 'package:graph/nav/redirect_to.dart';

import '../../../nav/routes.dart';
import '../../widgets/widgets.dart';
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
              value: data.createdAt.toString(),
            ),
          ],
        );
      },
    );
  }
}
