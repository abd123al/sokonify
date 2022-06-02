import 'package:blocitory/blocitory.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../gql/generated/graphql_api.graphql.dart';
import '../../../helpers/currency_formatter.dart';
import '../../../widgets/widgets.dart';
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
        final netIncome = Decimal.parse(data.totalSalesAmount) -
            Decimal.parse(data.totalExpensesAmount.replaceAll("-", ""));

        final List<StatTile> children = [
          StatTile(
            title: 'Total Income',
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
            title: 'Net Income',
            value: formatCurrency(netIncome.toString()),
            color: Colors.blue,
          ),
          StatTile(
            title: 'Net Profit',
            value: formatCurrency(data.netIncome),
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
            const Topper(
              label: "Today Statistics",
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
