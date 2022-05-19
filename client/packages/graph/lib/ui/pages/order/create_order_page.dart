import 'package:blocitory/blocitory.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/inventory/item_tile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/order_repository.dart';
import '../inventory/items_list_cubit.dart';
import 'create_order_cubit.dart';
import 'new_order_cubit.dart';
import 'orders_list_cubit.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    Key? key,
    required this.item,
    required this.items,
    required this.index,
  }) : super(key: key);
  final int index;
  final NewOrderItem item;
  final List<Items$Query$Item> items;

  @override
  State<StatefulWidget> createState() {
    return _OrderItemState();
  }
}

class _OrderItemState extends State<OrderItem> {
  final _quantityController = TextEditingController();

  @override
  void initState() {
    _quantityController.text = widget.item.quantity.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final cubit = BlocProvider.of<NewOrderCubit>(context);

    return ExpansionTile(
      title: Text(
        ItemTile.formatItemName(widget.item.item),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "${widget.item.quantity} Units",
        style: Theme.of(context).textTheme.titleSmall,
      ),
      trailing: Text(
        widget.item.subTotal,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(child: SizedBox()),
            ElevatedButton.icon(
              label: const Text("Edit"),
              onPressed: () {},
              icon: const Icon(
                Icons.edit, /* color: Colors.blue*/
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              label: const Text("Delete"),
              onPressed: () {},
              icon: const Icon(
                Icons.delete, /*color: Colors.red*/
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({
    Key? key,
  }) : super(key: key);

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
        title: const Text("New Order"),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return QueryBuilder<ResourceListData<Items$Query$Item>, ItemsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        return BlocBuilder<NewOrderCubit, NewOrder>(
          builder: (context, state) {
            final newOrderCubit = BlocProvider.of<NewOrderCubit>(context);

            final card = Card(
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    final List<Widget> children = [
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
                        items: data.items,
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
                  items: data.items,
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
                  Container(
                    color: Colors.blue.shade50,
                    child: ListTile(
                      title: Text(
                        "Total Amount",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      trailing: Text(
                        state.totalPrice,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _commentController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Add optional comment',
                      labelText: "Comment (Optional)",
                    ),
                  ),
                  MutationBuilder<CreateOrder$Mutation$Order, CreateOrderCubit,
                      OrderRepository>(
                    blocCreator: (r) => CreateOrderCubit(r),
                    onSuccess: (context, data) {
                      BlocProvider.of<OrdersListCubit>(context)
                          .addItem(Orders$Query$Order.fromJson(data.toJson()));
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
                                cubit.submit(
                                  OrderInput(
                                    type: OrderType.sale,
                                    comment: _commentController.text,
                                    items: state.items
                                        .map(
                                          (e) => OrderItemInput(
                                            price: e.customSellingPrice ??
                                                e.item.sellingPrice,
                                            itemId: e.item.id,
                                            quantity: e.quantity,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
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
  }

  @override
  void dispose() {
    _quantityAddController.dispose();
    _quantityEditController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}
