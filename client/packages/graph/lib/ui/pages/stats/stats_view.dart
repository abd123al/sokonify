import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../helpers/currency_formatter.dart';
import '../../widgets/topper.dart';
import 'stat_tile.dart';

class StatsData {
  final String sales;
  final String real;
  final String expenses;

  const StatsData({
    required this.sales,
    required this.real,
    this.expenses = "0.00",
  });
}

class StatsView extends StatelessWidget {
  const StatsView({
    Key? key,
    required this.data,
    required this.title,
    this.onPressed,
    this.sub = false,
  }) : super(key: key);

  final StatsData data;
  final String title;
  final VoidCallback? onPressed;

  /// If not overall we will show gross and sales only.
  final bool sub;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return _body(context);
      },
    );
  }

  ListView _body(BuildContext context) {
    //todo in large display use Grid/ but in phones ListView
    final List<Widget> children = [
      StatTile(
        title: 'Total Sales',
        value: formatCurrency(data.sales),
        color: Colors.brown,
      ),
      if (!sub)
        StatTile(
          title: 'Total Expenses',
          value: formatCurrency(data.expenses.replaceAll("-", "")),
          color: Colors.red,
        ),
      StatTile(
        title: 'Gross Profit',
        value: formatCurrency(data.real),
        color: Colors.blue,
      ),
      if (!sub)
        Builder(builder: (context) {
          final netProfit = Decimal.parse(data.real) -
              Decimal.parse(data.expenses.replaceAll("-", ""));

          return StatTile(
            title: 'Net Profit',
            value: formatCurrency(netProfit.toString()),
            color: Colors.green,
          );
        }),
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
  }
}
