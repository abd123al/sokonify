import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../../repositories/item_repository.dart';
import '../../widgets/widgets.dart';
import '../brand/brand.dart';
import '../product/product_tile.dart';
import '../product/products_list_cubit.dart';
import '../unit/unit_tile.dart';
import '../unit/units_list_cubit.dart';
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
  Units$Query$Unit? _unit;
  Brands$Query$Brand? _brand;
  DateTime? _selectedDate;

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
              builder: (context, products, _) {
                if (products.items.isEmpty) {
                  return CreateButton(
                    title: "Products",
                    onPressed: () => redirectTo(context, Routes.createProduct),
                  );
                }

                return SearchableDropdown<Products$Query$Product>(
                  asString: (i) => i.name.toLowerCase(),
                  data: products,
                  labelText: "Product",
                  hintText: "Select Product",
                  selectedItem: _product,
                  builder: (_, i) => ProductTile(product: i),
                  onChanged: (item) => setState(() {
                    _product = item;
                    _brand = null;
                  }),
                );
              },
            ),
            if (_product != null)
              QueryBuilder<ResourceListData<Brands$Query$Brand>,
                  BrandsListCubit>(
                retry: (cubit) => cubit.fetch(),
                builder: (context, data, _) {
                  final List<Brands$Query$Brand> brands = data.items
                      .where((e) => e.productId == _product!.id)
                      .toList();

                  return SearchableDropdown<Brands$Query$Brand>(
                    asString: (i) => i.name.toLowerCase(),
                    data: data.copyWith(
                      items: brands,
                    ),
                    labelText: "Brand (Optional)",
                    hintText: "Select Brand (Optional)",
                    onChanged: (item) => setState(() {
                      _brand = item;
                    }),
                    selectedItem: _brand,
                    builder: (_, i) => BrandTile(brand: i),
                  );
                },
              ),
            if (_product != null)
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  TextField(
                    autofocus: true,
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      hintText: 'The number of items',
                    ),
                  ),
                  QueryBuilder<ResourceListData<Units$Query$Unit>,
                      UnitsListCubit>(
                    retry: (cubit) => cubit.fetch(),
                    loadingWidget: const LoadingIndicator.small(),
                    retryWidget: const Icon(Icons.refresh),
                    builder: (context, units, _) {
                      if (units.items.isEmpty) {
                        return CreateButton(
                          title: "Units",
                          onPressed: () =>
                              redirectTo(context, Routes.createUnit),
                        );
                      }

                      return SearchableDropdown<Units$Query$Unit>(
                        asString: (i) => i.name.toLowerCase(),
                        data: units,
                        labelText: "Unit",
                        hintText: "Select Unit",
                        selectedItem: _unit,
                        builder: (_, i) => UnitTile(unit: i),
                        onChanged: (item) => setState(() {
                          _unit = item;
                        }),
                      );
                    },
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
                  InputDatePickerFormField(
                    firstDate: DateTime.now(),
                    fieldLabelText: 'Expire Date (Optional)',
                    fieldHintText: 'dd/mm/yyyy',
                    lastDate: DateTime.now().add(const Duration(days: 366 * 9)),
                    onDateSubmitted: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  TextField(
                    controller: _batchPriceController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Batch (Optional)',
                      hintText: 'Enter batch number',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  MutationBuilder<CreateItem$Mutation$Item, CreateItemCubit,
                      ItemRepository>(
                    blocCreator: (r) => CreateItemCubit(r),
                    onSuccess: (context, data) {
                      BlocProvider.of<ItemsListCubit>(context)
                          .addItem(Items$Query$Item.fromJson(data.toJson()));
                    },
                    pop: true,
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
                              unitId: _unit!.id,
                              description: _descriptionPriceController.text,
                              batch: _batchPriceController.text,
                              productId: _product!.id,
                              expiresAt: _selectedDate,
                              brandId: _brand?.id,
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
