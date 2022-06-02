import 'package:blocitory/helpers/resource_list_data.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SearchableDropdown<T> extends StatefulWidget {
  const SearchableDropdown({
    Key? key,
    required this.builder,
    required this.asString,
    required this.data,
    required this.hintText,
    required this.onChanged,
    this.selectedItem,
    required this.labelText,
    this.onChangedMultiSelection,
    this.selectedItems = const [],
  })  : isMultiSelectionMode = false,
        super(key: key);

  const SearchableDropdown.multiSelection({
    Key? key,
    required this.builder,
    required this.asString,
    required this.data,
    required this.hintText,
    this.selectedItem,
    required this.labelText,
    this.onChangedMultiSelection,
    this.selectedItems = const [],
  })  : onChanged = null,
        isMultiSelectionMode = true,
        super(key: key);

  final Widget Function(BuildContext context, T item) builder;
  final Function(T? item)? onChanged;
  final Function(List<T> list)? onChangedMultiSelection;
  final String Function(T item) asString;
  final String hintText;
  final String labelText;
  final bool isMultiSelectionMode;
  final ResourceListData<T> data;
  final T? selectedItem;
  final List<T> selectedItems;

  @override
  State<StatefulWidget> createState() {
    return _SearchableListState<T>();
  }
}

class _SearchableListState<T> extends State<SearchableDropdown<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        List<T> items = widget.data.items;

        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Builder(
            builder: (context) {
              if (widget.isMultiSelectionMode) {
                return DropdownSearch<T>.multiSelection(
                  showSearchBox: true,
                  itemAsString: (u) => widget.asString(u as T),
                  filterFn: (i, query) {
                    return widget
                        .asString(i as T)
                        .toLowerCase()
                        .contains(query ?? "");
                  },
                  isFilteredOnline: false,
                  mode: Mode.MENU,
                  items: items,
                  dropdownSearchDecoration: InputDecoration(
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: widget.onChangedMultiSelection,
                  selectedItems: widget.selectedItems,
                  searchDelay: const Duration(milliseconds: 0),
                  popupItemBuilder: (ont, i, __) => widget.builder(ont, i),
                  showClearButton: true,
                );
              }

              return DropdownSearch<T>(
                showSearchBox: true,
                itemAsString: (u) => widget.asString(u as T),
                filterFn: (i, query) {
                  return widget
                      .asString(i as T)
                      .toLowerCase()
                      .contains(query ?? "");
                },
                isFilteredOnline: false,
                mode: Mode.MENU,
                items: items,
                dropdownSearchDecoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  border: const OutlineInputBorder(),
                ),
                onChanged: widget.onChanged,
                selectedItem: widget.selectedItem,
                searchDelay: const Duration(milliseconds: 0),
                popupItemBuilder: (ont, i, __) => widget.builder(ont, i),
                showClearButton: true,
              );
            },
          ),
        );
      },
    );
  }
}
