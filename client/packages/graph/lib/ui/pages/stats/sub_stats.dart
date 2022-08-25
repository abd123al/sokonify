import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../../repositories/stats_repository.dart';
import '../../widgets/permission_builder.dart';
import 'stats_page.dart';
import 'stats_view.dart';
import 'sub_stats_cubit.dart';

class SubStats extends StatelessWidget {
  const SubStats({
    required this.filter,
    required this.id,
    Key? key,
    this.hasMore = true,
    required this.name,
  }) : super(key: key);

  final StatsFilter filter;
  final int id;
  final String name;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return PermissionBuilder(
      type: PermissionType.viewStats,
      builder: (context) {
        return _body(context);
      },
    );
  }

  _body(BuildContext context) {
    final statsArgs = StatsArgs(
      filter: filter,
      value: id,
    );

    final statsPageArgs = StatsPageArgs(
      args: statsArgs,
      name: name,
    );

    return BlocProvider(
      create: (_) {
        return SubStatsCubit(RepositoryProvider.of<StatsRepository>(context));
      },
      child: QueryBuilder<SubStats$Query, SubStatsCubit>(
        retry: (cubit) => cubit.fetch(statsArgs),
        initializer: (cubit) => cubit.fetch(statsArgs),
        builder: (context, data, _) {
          return StatsView(
            data: StatsData(
              real: data.grossProfit.real,
              sales: data.grossProfit.sales,
            ),
            title: hasMore ? "Today $name Stats" : "$name Stats",
            onPressed: hasMore
                ? () => redirectTo(
                      context,
                      Routes.stats,
                      args: statsPageArgs,
                    )
                : null,
            sub: true,
          );
        },
      ),
    );
  }
}
