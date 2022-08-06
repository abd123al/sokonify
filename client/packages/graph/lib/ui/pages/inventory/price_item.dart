import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/helpers/helpers.dart';

import 'prices_cubit.dart';

class PriceItem<T extends PricingCubit> extends StatefulWidget {
  const PriceItem({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);
  final int index;
  final Price item;

  @override
  State<StatefulWidget> createState() {
    return _PriceItemState<T>();
  }
}

class _PriceItemState<T extends PricingCubit> extends State<PriceItem<T>> {
  final _aController = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    _aController.text = widget.item.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<T>(context);

    return ExpansionTile(
      title: Text(
        widget.item.category.name,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: _editing
          ? TextFormField(
              controller: _aController,
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.number,
              autofocus: true,
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value == null || value.isEmpty || value == "0") {
                  return 'Please enter valid selling price..';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Enter Quantity',
                suffix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        cubit.editQuantity(
                          widget.index,
                          _aController.text,
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
                          _aController.text = widget.item.amount.toString();
                        });
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            )
          : null,
      trailing: Text(
        formatCurrency(widget.item.amount),
        style: Theme.of(context).textTheme.titleLarge,
      ),
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
    _aController.dispose();
    super.dispose();
  }
}
