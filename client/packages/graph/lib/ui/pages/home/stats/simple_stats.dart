import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import 'simple_stats_cubit.dart';
import 'stat_tile.dart';

/// This is used in home page only
class SimpleStats extends StatelessWidget {
  const SimpleStats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //todo in large display use Grid/ but in phones ListView
    return QueryBuilder<Stats$Query, SimpleStatsCubit>(
      retry: (cubit) => cubit.fetch(),
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
            GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              children: [
                StatTile(
                  title: 'Total Sales',
                  value: data.totalSalesAmount,
                  color: Colors.brown,
                  onTap: () {},
                ),
                StatTile(
                  title: 'Expenses',
                  value: data.totalExpensesAmount,
                  color: Colors.red,
                ),
                const StatTile(
                  title: 'Gross Income',
                  value: "783783.00 TZS",
                  color: Colors.blue,
                ),
                StatTile(
                  title: 'Net Income',
                  value: data.netIncome,
                  color: Colors.green,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
