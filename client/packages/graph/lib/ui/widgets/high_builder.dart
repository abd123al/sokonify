import 'package:blocitory/helpers/resource_list_data.dart';
import 'package:flutter/material.dart';

import 'empty_list.dart';

//todo move to blocitory.
class HighList<T> extends StatelessWidget {
  const HighList({
    Key? key,
    required this.items,
    required this.builder,
    this.shrinkWrap = false,
    this.emptyWord = "Nothing found here!",
  }) : super(key: key);

  final ResourceListData<T> items;
  final Function(BuildContext context, T item, Color? color) builder;
  final bool shrinkWrap;
  final String emptyWord;

  @override
  Widget build(BuildContext context) {
    if (items.items.isEmpty) {
      return EmptyList(
        message: emptyWord,
      );
    }

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        final item = items.items[index];
        final isNew = items.newItems.contains(item);

        Color? color;

        if (isNew) {
          color = Theme.of(context).secondaryHeaderColor;
        }

        return builder(context, item, color);
      },
      itemCount: items.items.length,
    );
  }
}
