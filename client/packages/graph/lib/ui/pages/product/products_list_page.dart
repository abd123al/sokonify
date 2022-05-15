import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../widgets/empty_list.dart';
import 'products_list_cubit.dart';

//todo show product count
class ProductList extends StatefulWidget {
  const ProductList({
    Key? key,
    this.onSelected,
    this.labelText,
  }) : super(key: key);

  final Function(Products$Query$Product)? onSelected;
  final String? labelText;

  @override
  State<StatefulWidget> createState() {
    return _ProductState();
  }
}

class _ProductState extends State<ProductList> {
  String _keyword = "";
  late bool selective;

  @override
  void initState() {
    selective = widget.onSelected != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Products$Query$Product>,
        ProductsListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        List<Products$Query$Product> units = data.items;

        if (_keyword.isNotEmpty) {
          units = units.where((e) {
            final searchable =  e.name.toLowerCase();
            return searchable.contains(_keyword.toLowerCase());
          }).toList();
        }

        if (units.isEmpty) {
          if (_keyword.isNotEmpty) {
            return TextButton(
              onPressed: () {},
              child: Text("$_keyword was found, but you can create it."),
            );
          }
          return const EmptyList(
            message: "No Products found, Please create some",
          );
        }

        return Column(
          children: [
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
                  labelText: widget.labelText,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.search_outlined),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final store = units[index];

                return Card(
                  elevation: 16,
                  child: ListTile(
                    title: Text(
                      store.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    onTap: widget.onSelected != null
                        ? () => widget.onSelected!(store)
                        : null,
                  ),
                );
              },
              itemCount: units.length,
            ),
          ],
        );
      },
    );
  }
}

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: const ProductList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => redirectTo(context, Routes.createProduct),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
