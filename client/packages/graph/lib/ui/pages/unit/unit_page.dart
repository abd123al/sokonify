import 'package:flutter/material.dart';
import 'package:graph/nav/redirect_to.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/routes.dart';
import '../../widgets/widgets.dart';
import '../stats/sub_stats.dart';
import 'unit_wrapper.dart';

class UnitPage extends StatelessWidget {
  const UnitPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(
        label: "Unit",
        onPressed: () {
          redirectTo(
            context,
            "${Routes.editUnit}/$id",
            replace: true,
          );
        },
      ),
      body: UnitWidget(
        id: id,
      ),
    );
  }
}

class UnitWidget extends StatelessWidget {
  const UnitWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return UnitWrapper(
      id: id,
      builder: (context, data) {
        return DetailsList(
          children: [
            SubStats(filter: StatsFilter.unit, id: id),
            ShortDetailTile(
              subtitle: "Unit Name",
              value: data.name,
            ),
            ShortDetailTile(
              subtitle: "Created By",
              value: data.user?.name,
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
