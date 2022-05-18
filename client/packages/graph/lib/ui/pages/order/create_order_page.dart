import 'package:blocitory/blocitory.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/inventory/item_tile.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../inventory/items_list_cubit.dart';
import 'new_order_cubit.dart';

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
      title: Text(ItemTile.formatItemName(widget.item.item)),
      subtitle: Text(
        "${widget.item.quantity} Units",
        style: Theme.of(context).textTheme.titleSmall,
      ),
      trailing: Text(
        widget.item.price,
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
            final cubit = BlocProvider.of<NewOrderCubit>(context);

            return ListView(
              controller: ScrollController(),
              children: [
                Card(
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
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
                          //popupTitle: const Text("Items List"),
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
                                  cubit.addItem(
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
                      ],
                    ),
                  ),
                ),
                ListView.builder(
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
                ),
                if (state.items.isNotEmpty)
                  Card(
                    color: Colors.blue.shade50,
                    elevation: 16,
                    child: ListTile(
                      title: const Text("Total Amount"),
                      trailing: Text(state.totalPrice),
                    ),
                  ),
                if (state.items.isNotEmpty)
                  Button(
                    title: "Submit",
                    callback: () {},
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _quantityEditController.dispose();
    super.dispose();
  }
}
