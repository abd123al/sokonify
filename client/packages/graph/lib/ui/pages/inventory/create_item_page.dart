import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';
import '../../widgets/widgets.dart';
import '../product/products_list_cubit.dart';
import 'create_item_cubit.dart';
import 'items_list_cubit.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateItemPageState();
  }
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _quantityController = TextEditingController();
  final _buyingPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _descriptionPriceController = TextEditingController();
  final _batchPriceController = TextEditingController();
  final _expireDateController = TextEditingController();
  Products$Query$Product? _product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Item"),
      ),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: ListView(
          children: [
            QueryBuilder<ResourceListData<Products$Query$Product>,
                ProductsListCubit>(
              retry: (cubit) => cubit.fetch(),
              builder: (context, list, _) {
                return SearchableDropdown<Products$Query$Product>(
                  builder: (context, p) {
                    return ListTile(
                      title: Text(p.name),
                    );
                  },
                  list: list.items,
                  compere: (p) => p.name,
                  onSelected: (p) {
                    setState(() {
                      _product = p;
                    });
                  },
                  hint: 'Select Product',
                );
              },
            ),
            if (_product != null)
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            hintText: 'The number of items',
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _buyingPriceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Buying Price',
                      hintText: 'Enter item buying price',
                    ),
                  ),
                  TextField(
                    controller: _sellingPriceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Selling Price',
                      hintText: 'Enter item selling price',
                    ),
                  ),
                  TextField(
                    controller: _descriptionPriceController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'Enter item selling price',
                    ),
                  ),
                  TextField(
                    controller: _batchPriceController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Batch (Optional)',
                      hintText: 'Enter batch number',
                    ),
                  ),
                  TextField(
                    controller: _expireDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: 'Expire Date (Optional)',
                      hintText: 'Enter expire date number',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  MutationBuilder<CreateItem$Mutation$Item, CreateItemCubit,
                      ItemRepository>(
                    blocCreator: (r) => CreateItemCubit(r),
                    onSuccess: (context, data) {
                      BlocProvider.of<ItemsListCubit>(context).addItem(Items$Query$Item.fromJson(data.toJson()));
                    },
                    pop: false,
                    builder: (context, cubit) {
                      return Button(
                        padding: EdgeInsets.zero,
                        callback: () {
                          cubit.submit(
                            ItemInput(
                              quantity:
                                  int.tryParse(_quantityController.text) ?? 0,
                              sellingPrice: _sellingPriceController.text,
                              buyingPrice: _buyingPriceController.text,
                              unitId: 2,
                              description: _descriptionPriceController.text,
                              batch: _batchPriceController.text,
                              productId: _product!.id,
                            ),
                          );
                        },
                        title: 'Submit',
                      );
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _buyingPriceController.dispose();
    _sellingPriceController.dispose();
    _descriptionPriceController.dispose();
    _batchPriceController.dispose();
    _expireDateController.dispose();
    super.dispose();
  }
}
