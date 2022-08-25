import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../stats/sub_stats.dart';

class CustomerStats extends StatelessWidget {
  const CustomerStats({
    Key? key,
    required this.customerId,
  }) : super(key: key);

  final int customerId;

  @override
  Widget build(BuildContext context) {
    return SubStats(
      filter: StatsFilter.customer,
      id: customerId,
      name: "Customer",
    );
  }
}
