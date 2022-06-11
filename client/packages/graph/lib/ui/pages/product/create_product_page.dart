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

class CreateProductPage extends StatelessWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Product"),
      ),
      body: const CreateProductWidget(),
    );
  }
}

class CreateProductWidget extends StatefulWidget {
  const CreateProductWidget({
    Key? key,
    this.message,
    this.onSuccess,
  }) : super(key: key);

  /// If users have no stores, they will be greeted by this msg
  /// which will aid them in creating new store.
  final String? message;

  /// When users have no default store we are going to switch to this
  /// one automatically
  final Function(BuildContext, CreateProduct$Mutation$Product)? onSuccess;

  @override
  State<StatefulWidget> createState() {
    return _CreateProductPageState();
  }
}

class _CreateProductPageState extends State<CreateProductWidget> {
  final _nameController = TextEditingController();
  List<Categories$Query$Category> _categories = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (widget.message != null)
                Text(
                  widget.message!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              const Divider(),
              TextField(
                autofocus: true,
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Product name',
                  hintText: 'Enter Product name',
                ),
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
              MutationBuilder<CreateProduct$Mutation$Product,
                  CreateProductCubit, ProductRepository>(
                blocCreator: (r) => CreateProductCubit(r),
                onSuccess: (context, data) {
                  BlocProvider.of<ProductsListCubit>(context)
                      .addItem(Products$Query$Product.fromJson(data.toJson()));
                },
                pop: widget.onSuccess == null,
                builder: (context, cubit) {
                  return Button(
                    padding: EdgeInsets.zero,
                    callback: () {
                      cubit.submit(
                        ProductInput(
                          name: _nameController.text,
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
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
