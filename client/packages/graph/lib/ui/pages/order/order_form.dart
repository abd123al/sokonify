import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/inventory/item_tile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';
import '../../../repositories/payment_repository.dart';
import '../../widgets/searchable_dropdown.dart';
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

class OrderForm<T extends OrderCubit> extends StatefulWidget {
  const OrderForm({
    Key? key,
    required this.isOrder,
    this.order,
    this.id,
  }) : super(key: key);

  final bool isOrder;
  final Order$Query$Order? order;
  final int? id;

  @override
  State<StatefulWidget> createState() {
    return _OrderFormState<T>();
  }
}

class _OrderFormState<T extends OrderCubit> extends State<OrderForm<T>> {
  final _quantityEditController = TextEditingController();
  final _quantityAddController = TextEditingController();
  final _commentController = TextEditingController();
  Items$Query$Item? _item;
  late bool _isEdit;

  @override
  void initState() {
    _isEdit = widget.order != null && widget.id != null;
    _commentController.text = widget.order?.comment ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildForm();
  }

  Widget _buildForm() {
    return BlocConsumer<T, NewOrder>(
      listener: (context, state) {
        if (state.hasError) {
          displayError(
            context: context,
            message: state.error!,
          );
        }
      },
      builder: (context, state) {
        final newOrderCubit = BlocProvider.of<T>(context);

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

                if (_isEdit) {
                  BlocProvider.of<OrdersListCubit>(context).updateItem(
                    (l) => l.firstWhere((e) => e.id == widget.id),
                    Orders$Query$Order.fromJson(data.toJson()),
                  );
                } else {
                  BlocProvider.of<PaymentsListCubit>(context)
                      .addItem(Payments$Query$Payment.fromJson(data.toJson()));
                }
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
                              return SearchableDropdown<
                                  Customers$Query$Customer>(
                                asString: (i) => i.name.toLowerCase(),
                                data: customers,
                                labelText: "Customer",
                                hintText: "Select Customer",
                                helperText:
                                    "This is the customer order will be billed to",
                                selectedItem: (e) => e.id == state.customer?.id,
                                onChanged: (customer) {
                                  newOrderCubit.changeCustomer(customer);
                                },
                              );
                            }),
                          const Divider(),
                          SearchableDropdown<Items$Query$Item>(
                            asString: (i) => ItemTile.formatItemName(i),
                            data: itemsData,
                            labelText: "Enter item",
                            hintText: "Type product name",
                            helperText: "Type items to add",
                            selectedItem: (e) => e == _item,
                            builder: (_, i) => ItemTile(item: i),
                            onChanged: (item) => setState(() {
                              _item = item;
                            }),
                          ),
                          const SizedBox(
                            height: 16,
                            width: 8,
                          ),
                          if (_item != null)
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
                                      _item!,
                                      int.parse(_quantityAddController.text),
                                    );

                                    //Resetting fields
                                    _quantityAddController.text = "";
                                    setState(() {
                                      _item = null;
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
                      const Divider(),
                      TextField(
                        controller: _commentController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add optional comment',
                          labelText: "Comment (Optional)",
                        ),
                      ),
                      const Divider(),
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
                                      final input = OrderInput(
                                        type: OrderType.sale,
                                        comment: _commentController.text,
                                        customerId: state.customer?.id,
                                        items: items,
                                      );

                                      if (_isEdit) {
                                        cubit.edit(
                                          EditOrderArguments(
                                            input: input,
                                            id: widget.id!,
                                          ),
                                        );
                                      } else {
                                        cubit.submit(input);
                                      }
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
