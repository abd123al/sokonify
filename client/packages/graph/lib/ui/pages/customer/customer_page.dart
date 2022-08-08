import 'package:flutter/material.dart';
import 'package:graph/gql/generated/graphql_api.dart';

import '../../../nav/nav.dart';
import '../order/orders_paginated_list.dart';
import '../payment/payments_paginated_list.dart';
import 'customer_details.dart';
import 'customer_stats.dart';

class CustomerTab {
  final Widget widget;
  final String title;

  CustomerTab(this.title, this.widget);
}

class CustomerPage extends StatefulWidget {
  const CustomerPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<CustomerPage> createState() => _HomePageState();
}

class _HomePageState extends State<CustomerPage> {
  late List<CustomerTab> list;

  @override
  void initState() {
    super.initState();

    list = [
      CustomerTab(
        "Details",
        CustomerDetails(id: widget.id),
      ),
      CustomerTab(
        "Payments",
        PaymentsPaginationList(
          value: widget.id,
          by: PaymentsBy.customer,
          word: 'Payments',
        ),
      ),
      CustomerTab(
        "Orders",
        OrdersPaginationList(
          value: widget.id,
          by: OrdersBy.customer,
        ),
      ),
      CustomerTab(
        "Stats",
        CustomerStats(
          customerId: widget.id,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: list.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: false,
            tabs: list
                .map(
                  (e) => Tab(text: e.title),
                )
                .toList(),
          ),
          title: const Text("Customer"),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Customer Details',
              onPressed: () {
                redirectTo(
                  context,
                  "${Routes.editCustomer}/${widget.id}",
                  replace: true,
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: list.map((e) => e.widget).toList(),
        ),
      ),
    );
  }
}
