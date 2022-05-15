import 'package:flutter/material.dart';

import 'empty_list.dart';

class SearchableList<T> extends StatefulWidget {
  const SearchableList({
    Key? key,
    required this.builder,
    required this.compare,
    required this.list,
    required this.hintName,
  }) : super(key: key);

  final Widget Function(BuildContext context, T item) builder;
  final String Function(T item) compare;
  final String hintName;
  final List<T> list;

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
        List<T> items = widget.list;

        if (_keyword.isNotEmpty) {
          items = items.where((e) {
            final searchable = widget.compare(e).toLowerCase();
            return searchable.contains(_keyword.toLowerCase());
          }).toList();
        }

        return Column(
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
            Builder(
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
                    message: "No ${widget.hintName}s found, Please create some",
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final store = items[index];
                      return widget.builder(context, store);
                    },
                    itemCount: items.length,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
