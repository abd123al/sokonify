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
  }) : super(key: key);

  final StatTab tab;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context){
        return StatsCubit(RepositoryProvider.of<StatsRepository>(context));
      },
      child: QueryBuilder<Stats$Query, StatsCubit>(
        retry: (cubit) => cubit.fetchByTimeframe(tab.type),
        initializer: (cubit) => cubit.fetchByTimeframe(tab.type),
        builder: (context, data, _) {
          return StatsView(
            data: data,
            title: "${tab.title} Statistics",
          );
        },
      ),
    );
  }
}

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

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
      children: list.map((e) => StatsWidget(tab: e)).toList(),
    );
  }
}
