import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graph/gql/generated/graphql_api.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../nav/nav.dart';
import '../../helpers/currency_formatter.dart';
import '../../'
    'widgets/widgets.dart';
import '../stats/sub_stats.dart';
import 'order_item_tile.dart';
import 'order_wrapper.dart';
import 'print.dart';
import 'total_amount_tile.dart';

/// There is no need at all to edit posted order.
class OrderPage extends StatelessWidget {
  const OrderPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(
        label: "Order #$id",
        onPressed: () {
          redirectTo(
            context,
            "${Routes.editOrder}/$id",
            replace: true,
          );
        },
      ),
      body: _build(),
    );
  }

  Widget _build() {
    return OrderWrapper(
      id: id,
      builder: (context, data) {
        final left = [
          if (data.status == OrderStatus.completed)
            SubStats(
              filter: StatsFilter.order,
              id: id,
              hasMore: false,
              name: "Order",
            ),
          if (data.customer?.name != null)
            ShortDetailTile(
                subtitle: "Customer", value: "${data.customer?.name}"),
          ShortDetailTile(subtitle: "Created At", value: "${data.createdAt}"),
          ShortDetailTile(subtitle: "Status", value: describeEnum(data.status)),
          ShortDetailTile(subtitle: "Pricing", value: data.pricing.name),
          ShortDetailTile(subtitle: "Comment", value: data.comment),
          if (data.payment != null)
            ShortDetailTile(
                subtitle: "Paid Amount",
                value: formatCurrency(data.payment!.amount)),
        ];

        final total = calculateTotal(
          data.orderItems.map(
            (e) => TotalPriceArgs(
              price: e.price,
              quantity: e.quantity,
            ),
          ),
        );

        final right = [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.orderItems.length,
            itemBuilder: (context, index) {
              final order = data.orderItems[index];

              return OrderItemTile(
                orderItem: order,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
          TotalAmountTile(
            amount: total,
          ),
        ];

        return Scaffold(
          body: OrientationLayoutBuilder(
            portrait: (context) => ListView(
              children: [
                ...left,
                const WordDivider(text: "Order Items"),
                ...right,
              ],
            ),
            landscape: (context) => Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 16,
                    child: ListView(
                      children: left,
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 16,
                    child: ListView(
                      children: right,
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Builder(
            builder: (context) {
              final group = AutoSizeGroup();

              _buildButton(
                String label,
                IconData icon,
                GestureTapCallback onTap,
              ) {
                return Expanded(
                  child: InkWell(
                    onTap: onTap,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: Theme.of(context).primaryColor,
                        ),
                        AutoSizeText(
                          label,
                          group: group,
                          minFontSize: 16,
                          maxFontSize: 20,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 60,
                width: double.infinity,
                child: Card(
                  elevation: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(
                        "Print Invoice",
                        Icons.print,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrintPage(
                                order: data,
                                id: id,
                              ),
                            ),
                          );
                        },
                      ),
                      if (data.payment != null)
                        _buildButton(
                          "Issue Receipt",
                          Icons.print,
                          () {},
                        ),
                      if (data.payment == null)
                        _buildButton(
                          "Complete Payment",
                          Icons.payment,
                          () {
                            redirectTo(
                              context,
                              "${Routes.createOrderPayment}/$id/$total",
                              replace: true,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
