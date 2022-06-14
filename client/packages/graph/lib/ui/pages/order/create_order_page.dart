import 'package:blocitory/blocitory.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/inventory/item_tile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';
import '../../../repositories/payment_repository.dart';
import '../customer/customer_tile.dart';
import '../customer/customers_list_cubit.dart';
import '../home/stats/simple_stats_cubit.dart';
import '../inventory/items_list_cubit.dart';
import '../payment/create_order_payment_cubit.dart';
import '../payment/payments_list_cubit.dart';
import 'create_order_cubit.dart';
import 'new_order_cubit.dart';
import 'order_item.dart';
import 'orders_list_cubit.dart';
import 'total_amount_tile.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({
    Key? key,
    this.isOrder = true,
  }) : super(key: key);

  final bool isOrder;

  @override
  State<StatefulWidget> createState() {
    return _CreateOrderPageState();
  }
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _quantityEditController = TextEditingController();
  final _quantityAddController = TextEditingController();
  final _commentController = TextEditingController();
  Items$Query$Item? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isOrder ? "New Order" : "New Sales"),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return BlocBuilder<NewOrderCubit, NewOrder>(
      builder: (context, state) {
        final newOrderCubit = BlocProvider.of<NewOrderCubit>(context);

        return QueryBuilder<ResourceListData<Items$Query$Item>, ItemsListCubit>(
          retry: (cubit) => cubit.fetch(),
          builder: (context, itemsData, _) {
            return MutationBuilder<CreateOrderPayment$Mutation$Payment,
                CreatePaymentCubit, PaymentRepository>(
              blocCreator: (r) => CreatePaymentCubit(r, () {
                BlocProvider.of<SimpleStatsCubit>(context).fetch();
              }),
              onSuccess: (context, data) {
                newOrderCubit.reset();

                BlocProvider.of<PaymentsListCubit>(context)
                    .addItem(Payments$Query$Payment.fromJson(data.toJson()));
              },
              pop: true,
              builder: (context, salesCubit) {
                final card = Card(
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QueryBuilder<
                        ResourceListData<Customers$Query$Customer>,
                        CustomersListCubit>(
                      retry: (cubit) => cubit.fetch(),
                      builder: (context, customers, _) {
                        final List<Widget> children = [
                          if (widget.isOrder)
                            Builder(builder: (context) {
                              return DropdownSearch<Customers$Query$Customer>(
                                showSearchBox: true,
                                itemAsString: (u) => u!.name,
                                filterFn: (i, query) {
                                  return i!.name
                                      .toLowerCase()
                                      .contains(query ?? "");
                                },
                                isFilteredOnline: false,
                                mode: Mode.MENU,
                                items: customers.items,
                                dropdownSearchDecoration: const InputDecoration(
                                  labelText: "Customer",
                                  hintText: "Add customer",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (customer) {
                                  newOrderCubit.changeCustomer(customer);
                                },
                                selectedItem: state.customer,
                                searchDelay: const Duration(milliseconds: 0),
                                popupItemBuilder: (_, i, __) =>
                                    CustomerTile(customer: i),
                                showClearButton: true,
                              );
                            }),
                          const SizedBox(
                            height: 16,
                            width: 8,
                          ),
                          DropdownSearch<Items$Query$Item>(
                            showSearchBox: true,
                            itemAsString: (u) => ItemTile.formatItemName(u!),
                            filterFn: (i, query) {
                              return ItemTile.formatItemName(i!)
                                  .toLowerCase()
                                  .contains(query ?? "");
                            },
                            isFilteredOnline: false,
                            mode: Mode.MENU,
                            items: itemsData.items,
                            dropdownSearchDecoration: const InputDecoration(
                              labelText: "Enter item",
                              hintText: "Type product name",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (item) => setState(() {
                              _selected = item;
                            }),
                            selectedItem: _selected,
                            searchDelay: const Duration(milliseconds: 0),
                            popupItemBuilder: (_, i, __) => ItemTile(item: i),
                            showClearButton: true,
                          ),
                          const SizedBox(
                            height: 16,
                            width: 8,
                          ),
                          if (_selected != null)
                            TextField(
                              controller: _quantityAddController,
                              textInputAction: TextInputAction.send,
                              keyboardType: TextInputType.number,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Enter Quantity',
                                labelText: "Quantity",
                                border: const OutlineInputBorder(),
                                suffixIcon: TextButton.icon(
                                  onPressed: () {
                                    newOrderCubit.addItem(
                                      _selected!,
                                      int.parse(_quantityAddController.text),
                                    );

                                    //Resetting fields
                                    _quantityAddController.text = "";
                                    setState(() {
                                      _selected = null;
                                    });
                                  },
                                  icon: const Icon(Icons.add_box, size: 40),
                                  label: const Text("Add"),
                                ),
                              ),
                            ),
                        ];
                        return ListView(
                          shrinkWrap: true,
                          children: children,
                        );
                      },
                    ),
                  ),
                );
                final list = ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return OrderItem(
                      item: item,
                      items: itemsData.items,
                      index: index,
                    );
                  },
                );
                final bottom = Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  child: Column(
                    children: [
                      const Divider(),
                      TotalAmountTile(
                        amount: state.totalPrice,
                      ),
                      TextField(
                        controller: _commentController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Add optional comment',
                          labelText: "Comment (Optional)",
                        ),
                      ),
                      MutationBuilder<CreateOrder$Mutation$Order,
                          CreateOrderCubit, OrderRepository>(
                        blocCreator: (r) => CreateOrderCubit(r),
                        onSuccess: (context, data) {
                          newOrderCubit.reset();

                          BlocProvider.of<OrdersListCubit>(context).addItem(
                              Orders$Query$Order.fromJson(data.toJson()));
                        },
                        pop: true,
                        builder: (context, cubit) {
                          return Row(
                            children: [
                              Flexible(
                                child: Button(
                                  color: Colors.red,
                                  padding: EdgeInsets.zero,
                                  callback: () {
                                    newOrderCubit.reset();
                                  },
                                  title: 'Clear',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Button(
                                  padding: EdgeInsets.zero,
                                  callback: () {
                                    final items = state.items
                                        .map(
                                          (e) => OrderItemInput(
                                            price: e.customSellingPrice ??
                                                e.item.sellingPrice,
                                            itemId: e.item.id,
                                            quantity: e.quantity,
                                          ),
                                        )
                                        .toList();

                                    if (widget.isOrder) {
                                      cubit.submit(
                                        OrderInput(
                                          type: OrderType.sale,
                                          comment: _commentController.text,
                                          customerId: state.customer?.id,
                                          items: items,
                                        ),
                                      );
                                    } else {
                                      salesCubit.submitSalesPayment(
                                        SalesInput(
                                          comment: _commentController.text,
                                          items: items,
                                        ),
                                      );
                                    }
                                  },
                                  title: 'Submit',
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );

                return OrientationLayoutBuilder(
                  portrait: (context) => ListView(
                    controller: ScrollController(),
                    children: [
                      card,
                      list,
                      if (state.items.isNotEmpty) bottom,
                    ],
                  ),
                  landscape: (context) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: card,
                      ),
                      Expanded(
                        child: ListView(
                          controller: ScrollController(),
                          children: [
                            list,
                            if (state.items.isNotEmpty) bottom,
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _quantityAddController.dispose();
    _quantityEditController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}
