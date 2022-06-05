import 'package:blocitory/helpers/resource_list_data.dart';
import 'package:flutter/material.dart';

import 'empty_list.dart';
import 'high_builder.dart';

class SearchableList<T> extends StatefulWidget {
  const SearchableList({
    Key? key,
    required this.builder,
    required this.compare,
    required this.data,
    required this.hintName,
    this.shrinkWrap = false,
    this.physics = const BouncingScrollPhysics(),
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  final Widget Function(BuildContext context, T item, Color? color) builder;
  final String Function(T item) compare;
  final String hintName;
  final bool shrinkWrap;
  final ResourceListData<T> data;
  final ScrollPhysics physics;
  final MainAxisSize mainAxisSize;

  @override
  State<StatefulWidget> createState() {
    return _SearchableListState<T>();
  }
}

class _SearchableListState<T> extends State<SearchableList<T>> {
  String _keyword = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        List<T> items = widget.data.items;

        if (_keyword.isNotEmpty) {
          items = items.where((e) {
            final searchable = widget.compare(e).toLowerCase();
            return searchable.contains(_keyword.toLowerCase());
          }).toList();
        }

        return Column(
          mainAxisSize: widget.mainAxisSize,
          children: [
            Card(
              elevation: 16,
              child: TextField(
                autofocus: false,
                keyboardType: TextInputType.text,
                onChanged: (s) {
                  setState(() {
                    _keyword = s;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search ${widget.hintName}s",
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.search_outlined),
                ),
              ),
            ),
            Flexible(
              child: Builder(
                builder: (context) {
                  if (items.isEmpty) {
                    if (_keyword.isNotEmpty) {
                      return TextButton(
                        onPressed: () {},
                        child:
                            Text("$_keyword was found, but you can create it."),
                      );
                    }
                    return EmptyList(
                      message:
                          "No ${widget.hintName}s found, Please create some",
                    );
                  }
                  return HighList<T>(
                    shrinkWrap: widget.shrinkWrap,
                    items: widget.data.copyWith(
                      items: items,
                    ),
                    physics: widget.physics,
                    builder: (context, item, color) {
                      return widget.builder(context, item, color);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
