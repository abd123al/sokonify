import 'package:blocitory/helpers/resource_query_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/helpers/helpers.dart';
import 'package:graph/ui/pages/stats/stats_view.dart';
import 'package:graph/ui/widgets/widgets.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../../repositories/stats_repository.dart';
import 'stats_cubit.dart';

class StatTab {
  final TimeframeType? type;
  final String title;
  final bool hasMultipleDays;

  StatTab(this.type, this.title, [this.hasMultipleDays = true]);
}

/// This is used in home page only
class StatsWidget extends StatelessWidget {
  const StatsWidget({
    Key? key,
    required this.tab,
    this.args,
    required this.name,
    this.range,
  }) : super(key: key);

  final StatTab tab;
  final String name;
  final StatsArgs? args;
  final DateTimeRange? range;

  @override
  Widget build(BuildContext context) {
    return PermissionBuilder(
      type: PermissionType.viewStats,
      builder: (context) {
        var statsArgs = args ?? StatsArgs();

        if (tab.type != null) {
          statsArgs.timeframe = tab.type;
        } else {
          statsArgs.startDate = range?.start;
          statsArgs.endDate = range?.end
              .add(const Duration(days: 1))
              .subtract(const Duration(seconds: 1));
        }

        return _body(statsArgs);
      },
    );
  }

  BlocProvider<StatsCubit> _body(StatsArgs statsArgs) {
    final word = "${tab.title} $name".cleanSpaces();

    return BlocProvider(
      create: (context) {
        return StatsCubit(RepositoryProvider.of<StatsRepository>(context));
      },
      child: QueryBuilder<Stats$Query, StatsCubit>(
        retry: (cubit) => cubit.fetch(statsArgs),
        initializer: (cubit) => cubit.fetch(statsArgs),
        builder: (context, data, _) {
          return ListView(
            children: [
              StatsView(
                data: StatsData(
                  real: data.grossProfit.real,
                  sales: data.grossProfit.sales,
                  expenses: data.totalExpensesAmount,
                ),
                sub: statsArgs.value != null,
                title: "$word Statistics".cleanSpaces(),
              ),
              const Topper(
                label: 'Actions',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    OutlinedButton(
                      onPressed: () => redirectTo(
                        context,
                        "${Routes.printSales}/$word",
                        args: statsArgs,
                      ),
                      child: Text("Print $word Sales".cleanSpaces()),
                    ),
                    OutlinedButton(
                      onPressed: () => redirectTo(
                        context,
                        Routes.convertStock,
                      ),
                      child: Text("Print ${tab.title} Expenses"),
                    ),
                    if (tab.hasMultipleDays)
                      OutlinedButton(
                        onPressed: () => redirectTo(
                          context,
                          "${Routes.printDailyStats}/$word",
                          args: statsArgs,
                        ),
                        child: Text("Print $word Daily Stats".cleanSpaces()),
                      ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class StatsPageArgs {
  final StatsArgs? args;
  final String name;

  StatsPageArgs({
    this.args,
    required this.name,
  });
}

class StatsPage extends StatefulWidget {
  const StatsPage({
    Key? key,
    this.args,
  }) : super(key: key);
  final StatsPageArgs? args;

  @override
  State<StatsPage> createState() => _HomePageState();
}

class _HomePageState extends State<StatsPage> {
  final List<StatTab> list = [
    StatTab(TimeframeType.today, "Today", false),
    StatTab(TimeframeType.yesterday, "Yesterday", false),
    StatTab(TimeframeType.thisWeek, "This Week"),
    StatTab(TimeframeType.lastWeek, "Last Week"),
    StatTab(TimeframeType.thisMonth, "This Month"),
    StatTab(TimeframeType.lastMonth, "Last Month"),
    StatTab(TimeframeType.thisYear, "This Year"),
    StatTab(null, "Custom Range"),
  ];

  DateTimeRange? _range;

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
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  initialDateRange: _range,
                  lastDate: DateTime.now(),
                  firstDate: DateTime(2022, 6),
                  currentDate: DateTime.now(),
                  initialEntryMode: DatePickerEntryMode.input,
                );

                if (picked != null) {
                  setState(() {
                    _range = picked;
                  });
                }
              },
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
                name: widget.args?.name ?? "",
                args: widget.args?.args,
                range: _range,
              ))
          .toList(),
    );
  }
}
