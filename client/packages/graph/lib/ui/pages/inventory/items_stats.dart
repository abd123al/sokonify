import 'package:blocitory/blocitory.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import '../../helpers/currency_formatter.dart';
import '../../widgets/topper.dart';
import '../stats/stat_tile.dart';
import 'items_stats_cubit.dart';

class InventoryStats extends StatelessWidget {
  const InventoryStats({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Categories$Query$Category category;

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<List<ItemsStats$Query$ItemsStats>, ItemsStatsCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, res, _) {
        final data = res.firstWhereOrNull(
          (e) => e.categoryId == category.id,
        );

        if (data == null) {
          return const SizedBox();
        }

        final List<StatTile> children = [
          StatTile(
            title: 'Total Cost',
            value: formatCurrency(data.totalCost),
            color: Colors.blue,
          ),
          StatTile(
            title: 'Expected Sales',
            value: formatCurrency(data.totalReturn),
            color: Colors.grey,
          ),
          StatTile(
            title: 'Expected Profit',
            value: formatCurrency(data.expectedProfit),
            color: Colors.green,
          ),
          const StatTile(
            title: 'Warnings',
            value: "0",
            color: Colors.red,
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
            Topper(
              label: "${category.name} Inventory",
              onPressed: (){},
              actionLabel: "Actions",
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
