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
    this.helperText,
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
    this.helperText,
  })  : onChanged = null,
        isMultiSelectionMode = true,
        super(key: key);

  final Widget Function(BuildContext context, T item) builder;
  final Function(T? item)? onChanged;
  final Function(List<T> list)? onChangedMultiSelection;
  final String Function(T item) asString;
  final String hintText;
  final String labelText;
  final String? helperText;
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
              final dropdownDecoratorProps = DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  border: const OutlineInputBorder(),
                ),
              );

              const searchFieldProps = TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Type here to search....",
                  border: OutlineInputBorder(),
                ),
              );

              if (widget.isMultiSelectionMode) {
                return DropdownSearch<T>.multiSelection(
                  itemAsString: (u) => widget.asString(u),
                  filterFn: (i, query) {
                    return widget.asString(i).toLowerCase().contains(query);
                  },
                  items: items,
                  dropdownDecoratorProps: dropdownDecoratorProps,
                  onChanged: widget.onChangedMultiSelection,
                  selectedItems: widget.selectedItems,
                  popupProps: const PopupPropsMultiSelection.menu(
                    showSearchBox: true,
                    searchFieldProps: searchFieldProps,
                    searchDelay: Duration(milliseconds: 0),
                    isFilterOnline: false,
                  ),
                );
              }

              return DropdownSearch<T>(
                itemAsString: (u) => widget.asString(u),
                filterFn: (i, query) {
                  return widget.asString(i).toLowerCase().contains(query);
                },
                items: items,
                dropdownDecoratorProps: dropdownDecoratorProps,
                onChanged: widget.onChanged,
                selectedItem: widget.selectedItem,
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: searchFieldProps,
                  searchDelay: Duration(milliseconds: 0),
                  isFilterOnline: false,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
