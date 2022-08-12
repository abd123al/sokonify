import 'package:blocitory/helpers/resource_list_data.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SearchableDropdown<T> extends StatefulWidget {
  const SearchableDropdown({
    Key? key,
    this.builder,
    required this.asString,
    required this.data,
    required this.hintText,
    required this.onChanged,
    this.selectedItem,
    required this.labelText,
    this.onChangedMultiSelection,
    this.helperText,
    this.isOptional = true,
    this.validator,
    this.autofocus = false,
  })  : isMultiSelectionMode = false,
        selectedItems = null,
        validatorMultiSelection = null,
        super(key: key);

  const SearchableDropdown.multiSelection({
    Key? key,
    this.builder,
    required this.asString,
    required this.data,
    required this.hintText,
    this.selectedItem,
    required this.labelText,
    this.onChangedMultiSelection,
    this.selectedItems,
    this.helperText,
    this.isOptional = true,
    this.validatorMultiSelection,
    this.autofocus = false,
  })  : onChanged = null,
        isMultiSelectionMode = true,
        validator = null,
        super(key: key);

  final Widget Function(BuildContext context, T item)? builder;
  final Function(T? item)? onChanged;
  final Function(List<T> list)? onChangedMultiSelection;
  final String Function(T item) asString;
  final String hintText;
  final String labelText;
  final String? helperText;
  final bool isMultiSelectionMode;
  final ResourceListData<T> data;
  final bool Function(T)? selectedItem;
  final List<T>? selectedItems;
  final bool isOptional;
  final bool autofocus;

  final FormFieldValidator<T>? validator;
  final FormFieldValidator<List<T>>? validatorMultiSelection;

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
                  helperText: widget.helperText,
                ),
              );

              const searchFieldProps = TextFieldProps(
                autofocus: true,
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
                  selectedItems: widget.selectedItems != null
                      ? widget.selectedItems!
                      : <T>[],
                  popupProps: PopupPropsMultiSelection.menu(
                    showSearchBox: true,
                    searchFieldProps: searchFieldProps,
                    searchDelay: const Duration(milliseconds: 0),
                    isFilterOnline: false,
                    itemBuilder: widget.builder != null
                        ? (c, i, _) => widget.builder!(c, i)
                        : null,
                  ),
                  validator: widget.validatorMultiSelection,
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
                selectedItem: widget.selectedItem != null
                    ? items.firstWhereOrNull((e) => widget.selectedItem!(e))
                    : null,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: searchFieldProps,
                  searchDelay: const Duration(milliseconds: 0),
                  isFilterOnline: false,
                  itemBuilder: widget.builder != null
                      ? (c, i, _) => widget.builder!(c, i)
                      : null,
                ),
                validator: (s) {
                  if (s == null && !widget.isOptional) {
                    return "This field is required.";
                  }

                  return null;
                },
              );
            },
          ),
        );
      },
    );
  }
}
