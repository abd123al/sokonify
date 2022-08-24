import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/brand_repository.dart';
import '../../widgets/form_list.dart';
import '../../widgets/searchable_dropdown.dart';
import '../product/products_list_cubit.dart';
import 'brands_list_cubit.dart';
import 'create_brand_cubit.dart';

class BrandForm extends StatefulWidget {
  const BrandForm({
    Key? key,
    required this.brand,
    required this.id,
  }) : super(key: key);

  final Brand$Query$Brand? brand;
  final int? id;

  @override
  State<StatefulWidget> createState() {
    return _CreateBrandPageState();
  }
}

class _CreateBrandPageState extends State<BrandForm> {
  final _nameController = TextEditingController();
  final _manufacturerController = TextEditingController();
  int? _productId;
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.brand != null && widget.id != null;
    _nameController.text = widget.brand?.name ?? "";
    _productId = widget.brand?.productId;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormList(
          children: [
            TextField(
              autofocus: true,
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Brand name',
                  hintText: 'Enter Brand name',
                  helperText: "eg. Antibiotics, Shoes"),
            ),
            QueryBuilder<ResourceListData<Products$Query$Product>,
                ProductsListCubit>(
              retry: (cubit) => cubit.fetch(),
              builder: (context, data, _) {
                return SearchableDropdown<Products$Query$Product>(
                  asString: (i) => i.name.toLowerCase(),
                  data: data,
                  labelText: "Product",
                  hintText: "Select Product",
                  onChanged: (item) => setState(() {
                    _productId = item?.id;
                  }),
                  selectedItem: (e) => e.id == _productId,
                );
              },
            ),
            TextField(
              controller: _manufacturerController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              maxLength: 250,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Brand Description (Optional)',
                hintText: "Anything you like here",
                helperText:
                    "This can help you remember what brand is about.",
              ),
            ),
            MutationBuilder<CreateBrand$Mutation$Brand, CreateBrandCubit,
                BrandRepository>(
              blocCreator: (r) => CreateBrandCubit(r),
              onSuccess: (context, data) {
                if (isEdit) {
                  BlocProvider.of<BrandsListCubit>(context).updateItem(
                    (l) => l.firstWhere((e) => e.id == widget.id),
                    Brands$Query$Brand.fromJson(data.toJson()),
                  );
                } else {
                  BlocProvider.of<BrandsListCubit>(context)
                      .addItem(Brands$Query$Brand.fromJson(data.toJson()));
                }
              },
              pop: true,
              builder: (context, cubit) {
                return Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    final input = BrandInput(
                      name: _nameController.text,
                      manufacturer: _manufacturerController.text,
                      productId: _productId!,
                    );

                    if (isEdit) {
                      cubit.edit(EditBrandArguments(
                        input: input,
                        id: widget.id!,
                      ));
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
    _manufacturerController.dispose();
    super.dispose();
  }
}
