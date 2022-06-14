import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/inventory/item_tile.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
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
  bool _editing = false;

  @override
  void initState() {
    _quantityController.text = widget.item.quantity.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<NewOrderCubit>(context);

    return ExpansionTile(
      title: Text(
        ItemTile.formatItemName(widget.item.item),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: _editing
          ? TextField(
              controller: _quantityController,
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter Quantity',
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        cubit.editQuantity(
                          widget.index,
                          int.parse(_quantityController.text),
                        );

                        setState(() {
                          _editing = false;
                        });
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Update"),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          _editing = false;
                          _quantityController.text =
                              widget.item.quantity.toString();
                        });
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            )
          : Text(
              "${widget.item.quantity} ${widget.item.item.unit.name}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
      trailing: Text(
        widget.item.subTotal,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      childrenPadding: const EdgeInsets.only(right: 16.0),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(child: SizedBox()),
            if (!_editing)
              ElevatedButton.icon(
                label: const Text("Edit"),
                onPressed: () {
                  setState(() {
                    _editing = true;
                  });
                },
                icon: const Icon(
                  Icons.edit, /* color: Colors.blue*/
                ),
              ),
            const SizedBox(width: 16),
            if (!_editing)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                label: const Text("Delete"),
                onPressed: () {
                  cubit.deleteItem(widget.index);
                },
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
