import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import '../../helpers/currency_formatter.dart';
import '../../widgets/topper.dart';
import '../home/stats/stat_tile.dart';

class StatsView extends StatelessWidget {
  const StatsView({
    Key? key,
    required this.data,
    required this.title,
    this.onPressed,
    this.overall = true,
  }) : super(key: key);

  final Stats$Query data;
  final String title;
  final VoidCallback? onPressed;

  /// If not overall we will show gross and sales only.
  final bool overall;

  @override
  Widget build(BuildContext context) {
    //todo in large display use Grid/ but in phones ListView
    return Builder(
      builder: (context) {
        final netProfit = Decimal.parse(data.grossProfit.real) -
            Decimal.parse(data.totalExpensesAmount.replaceAll("-", ""));

        final List<StatTile> children = [
          StatTile(
            title: 'Total Sales',
            value: formatCurrency(data.totalSalesAmount),
            color: Colors.brown,
            onTap: () {},
          ),
          StatTile(
            title: 'Total Expenses',
            value: formatCurrency(data.totalExpensesAmount.replaceAll("-", "")),
            color: Colors.red,
          ),
          StatTile(
            title: 'Gross Profit',
            value: formatCurrency(data.grossProfit.real),
            color: Colors.blue,
          ),
          StatTile(
            title: 'Net Profit',
            value: formatCurrency(netProfit.toString()),
            color: Colors.green,
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
              label: title,
              onPressed: onPressed,
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
