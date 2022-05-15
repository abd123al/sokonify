import 'package:flutter/material.dart';

//todo show product count
class SearchableDropdown<T> extends StatefulWidget {
  const SearchableDropdown({
    Key? key,
    required this.onSelected,
    required this.hint,
    required this.list,
    required this.builder,
    required this.compere,
  }) : super(key: key);

  final Function(T? item) onSelected;
  final Function(BuildContext, T item) builder;
  final String Function(T item) compere;
  final String hint;
  final List<T> list;

  @override
  State<StatefulWidget> createState() {
    return _ProductState<T>();
  }
}

class _ProductState<T> extends State<SearchableDropdown<T>> {
  String _keyword = "";
  T? _selected;

  @override
  void initState() {
    super.initState();
  }

  _reset() {
    widget.onSelected(null);
    setState(() {
      _keyword = "";
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        List<T> units = widget.list;

        if (_keyword.isNotEmpty) {
          units = units.where((e) {
            final searchable = widget.compere(e).toLowerCase();
            return searchable.contains(_keyword.toLowerCase());
          }).toList();
        }

        return Column(
          children: [
            if (_selected != null)
              Container(
                color: Theme.of(context).secondaryHeaderColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: widget.builder(
                        context,
                        _selected!,
                      ),
                    ),
                    InkWell(
                      child: IconButton(
                        onPressed: () {
                          _reset();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            if (_selected == null)
              Card(
                child: TextField(
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  onChanged: (s) {
                    setState(() {
                      _keyword = s;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Product',
                    labelText: widget.hint,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.search_outlined),
                  ),
                ),
              ),
            if (_selected == null)
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = units[index];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selected = item;
                        _keyword = "";
                      });

                      widget.onSelected(item);
                    },
                    child: widget.builder(context, item),
                  );
                },
                itemCount: units.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            if (units.isEmpty)
              const Center(
                child: Text("Nothing found..."),
              )
          ],
        );
      },
    );
  }
}
