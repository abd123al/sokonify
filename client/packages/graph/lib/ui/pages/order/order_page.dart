import 'package:blocitory/blocitory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/order/print.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';
import '../../helpers/currency_formatter.dart';
import 'order_page_cubit.dart';

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
        _buildTile(String key, String value) {
          return ListTile(
            title: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              key,
            ),
          );
        }

        final left = [
          if (data.customer?.name != null)
            _buildTile("Customer", "${data.customer?.name}"),
          _buildTile("Created At", "${data.createdAt}"),
          _buildTile("Status", describeEnum(data.status)),
        ];

        final right = [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.orderItems.length,
            itemBuilder: (context, index) {
              final order = data.orderItems[index];

              return ListTile(
                title: Text(
                  "${order.item.product.name} ${order.item.brand?.name ?? ""}",
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  formatCurrency(order.subTotalPrice),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  "${order.quantity} ${order.item.unit.name}",
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
          Container(
            color: Colors.blue.shade50,
            child: ListTile(
              title: Text(
                "Total Amount",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Text(
                "70000",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ];

        return Scaffold(
          body: OrientationLayoutBuilder(
            portrait: (context) => ListView(
              children: [
                ...left,
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
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.grey.shade50,
            unselectedItemColor: Theme.of(context).primaryColor,
            onTap: (n) {
              if (n == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrintPage(
                      order: data,
                      id: id,
                    ),
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.print,
                  //color: Colors.red,
                ),
                label: "Print Invoice",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.print),
                label: "Print Receipt",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.payment),
                label: "Complete Payment",
              ),
            ],
          ),
        );
      },
    );
  }
}
