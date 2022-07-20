import 'package:blocitory/blocitory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../../repositories/stats_repository.dart';
import 'stats_view.dart';
import 'sub_stats_cubit.dart';

class SubStats extends StatelessWidget {
  const SubStats({
    required this.filter,
    required this.id,
    Key? key,
  }) : super(key: key);

  final StatsFilter filter;
  final int id;

  @override
  Widget build(BuildContext context) {
    final args = StatsArgs(
      filter: filter,
      value: id,
    );

    return BlocProvider(
      create: (_) {
        return SubStatsCubit(RepositoryProvider.of<StatsRepository>(context));
      },
      child: QueryBuilder<SubStats$Query, SubStatsCubit>(
        retry: (cubit) => cubit.fetch(args),
        initializer: (cubit) => cubit.fetch(args),
        builder: (context, data, _) {
          return StatsView(
            data: StatsData(
              real: data.grossProfit.real,
              sales: data.grossProfit.sales,
            ),
            title: "Today ${describeEnum(filter)} stats",
            onPressed: () => redirectTo(
              context,
              Routes.stats,
              args: args,
            ),
            sub: true,
          );
        },
      ),
    );
  }
}
