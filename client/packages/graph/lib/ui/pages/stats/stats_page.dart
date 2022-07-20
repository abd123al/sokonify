import 'package:blocitory/helpers/resource_query_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/stats/stats_view.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/stats_repository.dart';
import 'stats_cubit.dart';

class StatTab {
  final TimeframeType type;
  final String title;

  StatTab(this.type, this.title);
}

/// This is used in home page only
class StatsWidget extends StatelessWidget {
  const StatsWidget({
    Key? key,
    required this.tab,
    this.args,
  }) : super(key: key);

  final StatTab tab;
  final StatsArgs? args;

  @override
  Widget build(BuildContext context) {
    var statsArgs = args ?? StatsArgs();

    statsArgs.timeframe = tab.type;

    return BlocProvider(
      create: (context) {
        return StatsCubit(RepositoryProvider.of<StatsRepository>(context));
      },
      child: QueryBuilder<Stats$Query, StatsCubit>(
        retry: (cubit) => cubit.fetch(statsArgs),
        initializer: (cubit) => cubit.fetch(statsArgs),
        builder: (context, data, _) {
          return StatsView(
            data: StatsData(
              real: data.grossProfit.real,
              sales: data.grossProfit.sales,
              expenses: data.totalExpensesAmount,
            ),
            sub: statsArgs.value != null,
            title: "${tab.title} Statistics",
          );
        },
      ),
    );
  }
}

class StatsPage extends StatefulWidget {
  const StatsPage({
    Key? key,
    this.args,
  }) : super(key: key);
  final StatsArgs? args;

  @override
  State<StatsPage> createState() => _HomePageState();
}

class _HomePageState extends State<StatsPage> {
  final List<StatTab> list = [
    StatTab(TimeframeType.today, "Today"),
    StatTab(TimeframeType.yesterday, "Yesterday"),
    StatTab(TimeframeType.thisWeek, "This Week"),
    StatTab(TimeframeType.lastWeek, "Last Week"),
    StatTab(TimeframeType.thisMonth, "This Month"),
    StatTab(TimeframeType.lastMonth, "Last Month"),
    StatTab(TimeframeType.thisYear, "This Year"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: list.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: list
                .map(
                  (e) => Tab(text: e.title),
                )
                .toList(),
          ),
          title: const Text("Statistics"),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              tooltip: 'Open QR Code Scanner',
              onPressed: () {},
            ),
          ],
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return TabBarView(
      children: list
          .map((e) => StatsWidget(
                tab: e,
                args: widget.args,
              ))
          .toList(),
    );
  }
}
