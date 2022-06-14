import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/product_repository.dart';
import '../../widgets/searchable_dropdown.dart';
import '../category/categories_list_cubit.dart';
import '../category/category_tile.dart';
import 'create_product_cubit.dart';
import 'products_list_cubit.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({
    Key? key,
    this.product,
  }) : super(key: key);

  final CreateProduct$Mutation$Product? product;

  @override
  State<StatefulWidget> createState() {
    return _CreateProductPageState();
  }
}

class _CreateProductPageState extends State<ProductForm> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  List<Categories$Query$Category> _categories = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              autofocus: true,
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Product name',
                  hintText: 'Enter Product name',
                  helperText: "eg. Paracetamol Tabs, Bicycle"),
            ),
            QueryBuilder<ResourceListData<Categories$Query$Category>,
                CategoriesListCubit>(
              retry: (cubit) => cubit.fetch(),
              builder: (context, data, _) {
                return SearchableDropdown<
                    Categories$Query$Category>.multiSelection(
                  asString: (i) => i.name.toLowerCase(),
                  data: data,
                  labelText: "Categories (Optional)",
                  hintText: "Select Categories (Optional)",
                  helperText:
                      "Grouping products into categories can help tracking them better.",
                  onChangedMultiSelection: (item) => setState(() {
                    _categories = item;
                  }),
                  selectedItems: _categories,
                  builder: (_, i) => CategoryTile(category: i),
                );
              },
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _descController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              maxLength: 250,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Product Description (Optional)',
                hintText: "Anything you like here",
                helperText: "This can help you remember something.",
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            MutationBuilder<CreateProduct$Mutation$Product, CreateProductCubit,
                ProductRepository>(
              blocCreator: (r) => CreateProductCubit(r),
              onSuccess: (context, data) {
                BlocProvider.of<ProductsListCubit>(context)
                    .addItem(Products$Query$Product.fromJson(data.toJson()));
              },
              pop: true,
              builder: (context, cubit) {
                return Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    cubit.submit(
                      ProductInput(
                        name: _nameController.text,
                        description: _descController.text,
                        categories: _categories.map((e) => e.id).toList(),
                      ),
                    );
                  },
                  title: 'Submit',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
