import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import '../../../../nav/nav.dart';
import '../../stats/stats_view.dart';
import 'simple_stats_cubit.dart';

/// This is used in home page only
class SimpleStats extends StatelessWidget {
  const SimpleStats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<Stats$Query, SimpleStatsCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        return StatsView(
          data: data,
          title: "Today Statistics",
          onPressed: () => redirectTo(context, Routes.stats),
        );
      },
    );
  }
}
