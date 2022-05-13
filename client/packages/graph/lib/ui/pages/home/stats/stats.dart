import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import 'stat_tile.dart';
import 'stats_cubit.dart';

class SimpleStats extends StatelessWidget {
  const SimpleStats({
    Key? key,
    this.timeframe = TimeframeType.today,
  }) : super(key: key);

  final TimeframeType timeframe;

  @override
  Widget build(BuildContext context) {
    final args = StatsArgs(timeframe: timeframe);
    //todo in large display use Grid/ but in phones ListView
    return QueryBuilder<Stats$Query, StatsCubit>(
      initializer: (cubit) => cubit.fetch(args),
      retry: (cubit) => cubit.fetch(args),
      builder: (context, data, _) {
        return ListView(
          shrinkWrap: true,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today Statistics",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('More'),
                    )
                  ],
                ),
              ),
            ),
            StatTile(
              title: 'Total Sales',
              value: data.totalSalesAmount,
              color: Colors.green,
            ),
            StatTile(
              title: 'Expenses',
              value: data.totalExpensesAmount,
              color: Colors.red,
            ),
            const StatTile(
              title: 'Net Profit',
              value: "783783.00 TZS",
              color: Colors.blue,
            ),
          ],
        );
      },
    );
  }
}
