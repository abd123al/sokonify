import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/product_repository.dart';
import '../../widgets/searchable_dropdown.dart';
import '../category/categories_list_cubit.dart';
import 'create_product_cubit.dart';
import 'products_list_cubit.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({
    Key? key,
    required this.product,
    required this.id,
  }) : super(key: key);

  final Product$Query$Product? product;
  final int? id;

  @override
  State<StatefulWidget> createState() {
    return _CreateProductPageState();
  }
}

class _CreateProductPageState extends State<ProductForm> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  late List<Categories$Query$Category> _categories;

  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.product != null && widget.id != null;
    _nameController.text = widget.product?.name ?? "";
    _descController.text = widget.product?.description ?? "";
    _categories = widget.product?.categories
            ?.map((e) => Categories$Query$Category.fromJson(e.toJson()))
            .toList() ??
        [];
  }

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
                final List<Categories$Query$Category> cats = data.items
                    .where((e) => e.type == CategoryType.category)
                    .toList();

                return SearchableDropdown<
                    Categories$Query$Category>.multiSelection(
                  asString: (i) => i.name.toLowerCase(),
                  data: data.copyWith(
                    items: cats,
                  ),
                  labelText: "Categories (Optional)",
                  hintText: "Select Categories (Optional)",
                  helperText:
                      "Grouping products into categories can help tracking them better.",
                  onChangedMultiSelection: (item) => setState(() {
                    _categories = item;
                  }),
                  selectedItems: _categories,
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
                if (isEdit) {
                  BlocProvider.of<ProductsListCubit>(context).updateItem(
                    (l) => l.firstWhere((e) => e.id == widget.id),
                    Products$Query$Product.fromJson(data.toJson()),
                  );
                } else {
                  BlocProvider.of<ProductsListCubit>(context)
                      .addItem(Products$Query$Product.fromJson(data.toJson()));
                }
              },
              pop: true,
              builder: (context, cubit) {
                return Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    final input = ProductInput(
                      name: _nameController.text,
                      description: _descController.text,
                      categories: _categories.map((e) => e.id).toList(),
                    );

                    if (isEdit) {
                      cubit.edit(widget.id!, input);
                    } else {
                      cubit.create(input);
                    }
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
