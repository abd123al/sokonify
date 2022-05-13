import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
        //Function which returns list builder
        Widget _buildGrid(int crossAxisCount) {
          return GridView(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
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
          );
        }

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
            ScreenTypeLayout.builder(
              mobile: (BuildContext context) => OrientationLayoutBuilder(
                portrait: (context) => _buildGrid(2),
                landscape: (context) => _buildGrid(4),
              ),
              tablet: (BuildContext context) => _buildGrid(4),
              desktop: (BuildContext context) => _buildGrid(4),
              watch: (BuildContext context) => _buildGrid(1),
            ),
          ],
        );
      },
    );
  }
}
