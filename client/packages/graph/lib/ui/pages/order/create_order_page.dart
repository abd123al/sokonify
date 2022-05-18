import 'package:blocitory/helpers/resource_list_data.dart';
import 'package:blocitory/helpers/resource_query_widget.dart';
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
    final cubit = BlocProvider.of<NewOrderCubit>(context);

    if (widget.item.state == NewOrderItemState.searching) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Autocomplete<Items$Query$Item>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<Items$Query$Item>.empty();
            }

            return widget.items.where((option) {
              final i = ItemTile.formatItemName(option).toLowerCase();
              return i.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (selection) {
            cubit.addItem(selection);
          },
        ),
      );
    } else if (widget.item.state == NewOrderItemState.entering) {
      return Column(
        children: [
          Container(
            color: Colors.blue.shade50,
            child: Text(ItemTile.formatItemName(widget.item.item!)),
          ),
          TextField(
            autofocus: true,
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter quantity',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.editQuantity(
                widget.index,
                int.tryParse(_quantityController.text) ?? 0,
              );
            },
            child: const Text('Save'),
          ),
        ],
      );
    } else if (widget.item.state == NewOrderItemState.editing) {
      return ListTile(
        title: Text(ItemTile.formatItemName(widget.item.item!)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.cancel, color: Colors.grey),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.save, color: Colors.blue),
            )
          ],
        ),
        subtitle: TextField(
          autofocus: true,
          controller: _quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter quantity',
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Text(
              "${(widget.index)}. ${ItemTile.formatItemName(widget.item.item!)}"),
          Text(
            widget.item.price,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.item.quantity.toString()),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }
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
  final _quantityController = TextEditingController();

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
            return ListView.builder(
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
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
