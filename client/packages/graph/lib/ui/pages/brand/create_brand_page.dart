import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/brand_repository.dart';
import '../../widgets/searchable_dropdown.dart';
import '../product/products_list_cubit.dart';
import 'brands_list_cubit.dart';
import 'create_brand_cubit.dart';

class CreateBrandPage extends StatefulWidget {
  const CreateBrandPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateBrandPageState();
  }
}

class _CreateBrandPageState extends State<CreateBrandPage> {
  final _nameController = TextEditingController();
  int? _productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Brand"),
      ),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return MutationBuilder<CreateBrand$Mutation$Brand, CreateBrandCubit,
        BrandRepository>(
      blocCreator: (r) => CreateBrandCubit(r),
      onSuccess: (context, data) {
        BlocProvider.of<BrandsListCubit>(context)
            .addItem(Brands$Query$Brand.fromJson(data.toJson()));
      },
      pop: true,
      builder: (context, cubit) {
        return Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
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
                const SizedBox(height: 8),
                if (_productId != null) ...[
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Brand name',
                      hintText: 'Enter brand name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Button(
                    padding: EdgeInsets.zero,
                    callback: () {
                      cubit.create(
                        BrandInput(
                          name: _nameController.text,
                          productId: _productId!,
                        ),
                      );
                    },
                    title: 'Submit',
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
