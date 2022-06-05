import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import '../../helpers/currency_formatter.dart';
import '../../widgets/topper.dart';
import '../home/stats/stat_tile.dart';
import 'items_stats_cubit.dart';


class InventoryStats extends StatelessWidget {
  const InventoryStats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ItemsStats$Query$ItemsStats, ItemsStatsCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        final List<StatTile> children = [
          StatTile(
            title: 'Total Cost',
            value: formatCurrency(data.totalCost),
            color: Colors.blue,
          ),
          StatTile(
            title: 'Expected Profit',
            value: formatCurrency(data.expectedProfit),
            color: Colors.green,
          ),
          const StatTile(
            title: 'Near Expire Date',
            value: "0",
            color: Colors.red,
          ),
          const StatTile(
            title: 'Near Out of Stock',
            value: "0",
            color: Colors.grey,
          ),
        ];

        //Function which returns list builder
        _buildGrid(int crossAxisCount, double childAspectRatio) {
          return GridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
            ),
            children: children,
          );
        }

        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            const Topper(
              label: "Inventory",
            ),
            ScreenTypeLayout.builder(
              mobile: (BuildContext context) => OrientationLayoutBuilder(
                portrait: (context) => _buildGrid(2, 2.6),
                landscape: (context) => _buildGrid(4, 3),
              ),
              tablet: (BuildContext context) => _buildGrid(4, 3),
              desktop: (BuildContext context) => _buildGrid(4, 3),
              watch: (BuildContext context) => _buildGrid(2, 2.6),
            ),
          ],
        );
      },
    );
  }
}
