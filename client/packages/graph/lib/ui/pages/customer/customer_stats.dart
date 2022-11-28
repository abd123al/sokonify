import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../stats/sub_stats.dart';

class CustomerStats extends StatelessWidget {
  const CustomerStats({
    Key? key,
    required this.customerId,
    required this.name,
  }) : super(key: key);

  final int customerId;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SubStats(
      filter: StatsFilter.customer,
      id: customerId,
      name: name,
    );
  }
}
