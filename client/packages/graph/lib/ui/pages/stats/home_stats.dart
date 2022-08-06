import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/permission_builder.dart';
import 'home_stats_cubit.dart';
import 'stats_view.dart';

/// This is used in home page only
class HomeStats extends StatelessWidget {
  const HomeStats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PermissionBuilder(
      type: PermissionType.viewStats,
      builder: (context) {
        return QueryBuilder<Stats$Query, SimpleStatsCubit>(
          retry: (cubit) => cubit.fetch(),
          builder: (context, data, _) {
            return StatsView(
              data: StatsData(
                real: data.grossProfit.real,
                sales: data.grossProfit.sales,
                expenses: data.totalExpensesAmount,
              ),
              title: "Today Statistics",
              onPressed: () => redirectTo(context, Routes.stats),
            );
          },
        );
      },
    );
  }
}
