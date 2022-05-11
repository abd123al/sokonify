import 'package:flutter/material.dart';

import 'stat_tile.dart';

class SimpleStats extends StatelessWidget {
  const SimpleStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //todo in large display use Grid/ but in phones ListView
    return ListView(
      shrinkWrap: true,
      children: const [
        StatTile(
          title: 'Total Sales',
          value: "34444.00 TZS",
          color: Colors.green,
        ),
        StatTile(
          title: 'Expenses',
          value: "34444.00 TZS",
          color: Colors.red,
        ),
        StatTile(
          title: 'Net Profit',
          value: "783783.00 TZS",
          color: Colors.blue,
        ),
      ],
    );
  }
}
