import 'package:auto_size_text/auto_size_text.dart';
import 'package:blocitory/blocitory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';
import '../../helpers/currency_formatter.dart';
import '../../widgets/widgets.dart';
import '../../widgets/word_divider.dart';
import '../payment/create_order_payment_page.dart';
import 'order_item_tile.dart';
import 'order_page_cubit.dart';
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
      appBar: AppBar(
        title: Text("Order #$id"),
      ),
      body: BlocProvider(
        create: (context) {
          return OrderPageCubit(
            RepositoryProvider.of<OrderRepository>(context),
          );
        },
        child: Builder(builder: (context) {
          return _build();
        }),
      ),
    );
  }

  Widget _build() {
    return QueryBuilder<Order$Query$Order, OrderPageCubit>(
      retry: (cubit) => cubit.fetch(id),
      initializer: (cubit) => cubit.fetch(id),
      builder: (context, data, _) {
        final left = [
          if (data.customer?.name != null)
            ShortDetailTile(
                subtitle: "Customer", value: "${data.customer?.name}"),
          ShortDetailTile(subtitle: "Created At", value: "${data.createdAt}"),
          ShortDetailTile(subtitle: "Status", value: describeEnum(data.status)),
          if (data.payment != null)
            ShortDetailTile(
                subtitle: "Paid Amount",
                value: formatCurrency(data.payment!.amount)),
        ];

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
            amount: calculateTotal(
              data.orderItems.map(
                (e) => TotalPriceArgs(
                  price: e.price,
                  quantity: e.quantity,
                ),
              ),
            ),
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
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return CreatePaymentWidget(
                                  amount: '36677',
                                  orderId: id,
                                );
                              },
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
