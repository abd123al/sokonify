import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../../repositories/item_repository.dart';
import '../../widgets/widgets.dart';
import '../brand/brand.dart';
import '../category/categories_list_cubit.dart';
import '../category/pricing_builder.dart';
import '../product/products_list_cubit.dart';
import '../unit/units_list_cubit.dart';
import 'create_item_cubit.dart';
import 'items_list_cubit.dart';
import 'price_item.dart';
import 'prices_cubit.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({
    Key? key,
    required this.item,
    required this.id,
    this.pricing,
  }) : super(key: key);

  final Item$Query$Item? item;
  final int? id;
  final Categories$Query$Category? pricing;

  @override
  State<StatefulWidget> createState() {
    return _ItemFormState();
  }
}

class _ItemFormState extends State<ItemForm> {
  final _batchPriceController = TextEditingController();
  final _buyingPriceController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionPriceController = TextEditingController();
  final _expireDateController = TextEditingController();
  final _quantityController = TextEditingController();
  final _amountController = TextEditingController();
  int? _productId;
  int? _unitId;
  int? _brandId;
  DateTime? _expireDate;
  late List<Categories$Query$Category> _categories;
  Categories$Query$Category? _item;

  late bool isEdit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isEdit = widget.item != null && widget.id != null;

    _productId = widget.item?.product.id;
    _unitId = widget.item?.unit.id;
    _brandId = widget.item?.brand?.id;
    _item = widget.pricing;

    _categories = widget.item?.categories
            ?.map((e) => Categories$Query$Category.fromJson(e.toJson()))
            .toList() ??
        [];

    _batchPriceController.text = widget.item?.batch ?? "";
    _buyingPriceController.text = widget.item?.buyingPrice ?? "";
    _descriptionPriceController.text = widget.item?.description ?? "";
    _expireDateController.text = widget.item?.expiresAt.toString() ?? "";
    _quantityController.text = widget.item?.quantity.toString() ?? "";
    _expireDate = widget.item?.expiresAt;
    _dateController.text = formatDate(widget.item?.expiresAt) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return NewPriceCubit();
      },
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Builder(
      builder: (context) {
        final priceCubit = BlocProvider.of<NewPriceCubit>(context);

        return BlocConsumer<NewPriceCubit, NewPrice>(
          listener: (context, state) {
            if (state.hasError) {
              displayError(
                context: context,
                message: state.error!,
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: FormList(
                  children: [
                    if (isEdit)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Edit item may result into inconsistency data. "
                            "Make sure you know what you are doing.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ),
                      ),
                    QueryBuilder<ResourceListData<Products$Query$Product>,
                        ProductsListCubit>(
                      retry: (cubit) => cubit.fetch(),
                      builder: (context, products, _) {
                        if (products.items.isEmpty) {
                          return CreateButton(
                            title: "Products",
                            onPressed: () =>
                                redirectTo(context, Routes.createProduct),
                          );
                        }

                        return SearchableDropdown<Products$Query$Product>(
                          asString: (i) => i.name.toLowerCase(),
                          data: products,
                          labelText: "Product",
                          isOptional: false,
                          hintText: "Select Product",
                          helperText: "Choose product which you want to add stock",
                          selectedItem: (e) => e.id == _productId,
                          onChanged: (p) => setState(() {
                            _productId = p?.id;
                            _brandId = null;
                          }),
                        );
                      },
                    ),
                    QueryBuilder<ResourceListData<Brands$Query$Brand>,
                        BrandsListCubit>(
                      retry: (cubit) => cubit.fetch(),
                      builder: (context, data, _) {
                        final List<Brands$Query$Brand> brands = data.items
                            .where((e) => e.productId == _productId)
                            .toList();

                        return SearchableDropdown<Brands$Query$Brand>(
                          asString: (i) => i.name.toLowerCase(),
                          data: data.copyWith(
                            items: brands,
                          ),
                          isOptional: true,
                          labelText: "Brand (Optional)",
                          hintText: "Select Brand (Optional)",
                          selectedItem: (e) => e.id == _brandId,
                          onChanged: (item) => setState(() {
                            _brandId = item?.id;
                          }),
                        );
                      },
                    ),
                    QueryBuilder<ResourceListData<Categories$Query$Category>,
                        CategoriesListCubit>(
                      retry: (cubit) => cubit.fetch(),
                      builder: (context, data, _) {
                        final List<Categories$Query$Category> cats = data.items
                            .where((e) => e.type == CategoryType.subcategory)
                            .toList();

                        if (cats.isEmpty) {
                          return const SizedBox();
                        }

                        return SearchableDropdown<
                            Categories$Query$Category>.multiSelection(
                          asString: (i) => i.name.toLowerCase(),
                          data: ResourceListData<Categories$Query$Category>()
                              .copyWith(items: cats),
                          labelText: "Stock Categories (Optional)",
                          hintText: "Select Stock Categories (Optional)",
                          helperText:
                              "Grouping stocks into categories can help tracking them better.",
                          onChangedMultiSelection: (item) => setState(() {
                            _categories = item;
                          }),
                          selectedItems: _categories,
                        );
                      },
                    ),
                    TextFormField(
                      autofocus: !isEdit,
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quantity',
                        hintText: 'The number of items',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "0") {
                          return 'Please valid enter quantity..';
                        }
                        return null;
                      },
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
                          isOptional: false,
                          labelText: "Unit",
                          hintText: "Select Unit",
                          selectedItem: (e) => e.id == _unitId,
                          onChanged: (item) => setState(() {
                            _unitId = item?.id;
                          }),
                        );
                      },
                    ),
                    TextFormField(
                      controller: _buyingPriceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Buying price',
                        hintText: 'Enter item buying price',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "0") {
                          return 'Please valid buying price';
                        }
                        return null;
                      },
                    ),
                    PricingBuilder(
                      builder: (context, cats) {
                        return Column(
                          children: [
                            SearchableDropdown<Categories$Query$Category>(
                              asString: (i) => i.name,
                              data: cats,
                              labelText: "Enter selling price",
                              hintText: "Type pricing name",
                              helperText: "Type pricing to add",
                              selectedItem: (e) => e.id == _item?.id,
                              onChanged: (item) => setState(() {
                                _item = item;
                              }),
                            ),
                            const SizedBox(
                              height: 16,
                              width: 8,
                            ),
                            if (_item != null)
                              TextFormField(
                                controller: _amountController,
                                textInputAction: TextInputAction.send,
                                keyboardType: TextInputType.number,
                                autofocus: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == "0") {
                                    return 'Please enter valid selling price..';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter ${_item?.name ?? ""} price',
                                  labelText: "${_item?.name ?? ""} price",
                                  border: const OutlineInputBorder(),
                                  suffixIcon: TextButton.icon(
                                    onPressed: () {
                                      priceCubit.addItem(
                                        _item!,
                                        _amountController.text,
                                      );

                                      //Resetting fields
                                      _amountController.text = "";
                                      setState(() {
                                        _item = null;
                                      });
                                    },
                                    icon: const Icon(Icons.add_box, size: 40),
                                    label: const Text("Add"),
                                  ),
                                ),
                              ),
                            Container(
                              color: Theme.of(context).secondaryHeaderColor,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.prices.length,
                                itemBuilder: (context, index) {
                                  final item = state.prices[index];

                                  return PriceItem(
                                    item: item,
                                    index: index,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    TextField(
                      controller: _descriptionPriceController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description (Optional)',
                        hintText: 'Enter item selling price',
                      ),
                    ),
                    TextField(
                      controller: _batchPriceController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Batch (Optional)',
                        hintText: 'Enter batch number',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: _dateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Expire Date (Optional)',
                        hintText: 'Enter expire date here',
                      ),
                      onTap: () async {
                        // Below line stops keyboard from appearing
                        FocusScope.of(context).requestFocus(FocusNode());

                        final v = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365 * 9)),
                          firstDate: DateTime.now(),
                        );

                        setState(() {
                          _expireDate = v;
                        });

                        //For just showing
                        _dateController.text = formatDate(v) ?? "";
                      },
                    ),
                    MutationBuilder<CreateItem$Mutation$Item, CreateItemCubit,
                        ItemRepository>(
                      blocCreator: (r) => CreateItemCubit(r),
                      onSuccess: (context, data) {
                        if (!isEdit) {
                          BlocProvider.of<ItemsListCubit>(context).addItem(
                              Items$Query$Item.fromJson(data.toJson()));
                        } else {
                          BlocProvider.of<ItemsListCubit>(context).updateItem(
                            (l) => l.firstWhere((e) => e.id == widget.id),
                            Items$Query$Item.fromJson(data.toJson()),
                          );
                        }
                      },
                      pop: true,
                      builder: (context, cubit) {
                        return Button(
                          padding: EdgeInsets.zero,
                          callback: () {
                            if (priceCubit.validate()) {
                              if (_formKey.currentState!.validate()) {
                                final input = ItemInput(
                                  quantity: int.parse(_quantityController.text),
                                  buyingPrice: _buyingPriceController.text,
                                  unitId: _unitId!,
                                  description: _descriptionPriceController.text,
                                  batch: _batchPriceController.text,
                                  productId: _productId!,
                                  expiresAt: _expireDate,
                                  brandId: _brandId,
                                  categories:
                                      _categories.map((e) => e.id).toList(),
                                  prices: state.prices
                                      .map((e) => PriceInput(
                                            amount: e.amount,
                                            categoryId: e.category.id,
                                          ))
                                      .toList(),
                                );

                                if (!isEdit) {
                                  cubit.create(input);
                                } else {
                                  cubit.edit(widget.id!, input);
                                }
                              }
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
          },
        );
      },
    );
  }

  String? formatDate(DateTime? v) {
    if (v != null) {
      return DateFormat('dd/MM/yyyy').format(v);
    }

    return null;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _quantityController.dispose();
    _buyingPriceController.dispose();
    _descriptionPriceController.dispose();
    _dateController.dispose();
    _batchPriceController.dispose();
    _expireDateController.dispose();
    super.dispose();
  }
}
