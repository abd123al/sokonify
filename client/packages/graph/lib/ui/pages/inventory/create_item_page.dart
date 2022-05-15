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
  final _passwordController = TextEditingController();
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
        child: Column(
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
              Column(
                children: [
                  TextField(
                    autofocus: true,
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Facility name',
                      hintText: 'Enter your Shop name',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  MutationBuilder<ItemPartsMixin, CreateItemCubit,
                      ItemRepository>(
                    blocCreator: (r) => CreateItemCubit(r),
                    onSuccess: (context, data) {
                      BlocProvider.of<ItemsListCubit>(context).addItem(data);
                    },
                    pop: true,
                    builder: (context, cubit) {
                      return Button(
                        padding: EdgeInsets.zero,
                        callback: () {
                          cubit.submit(
                            ItemInput(
                              quantity: 454,
                              sellingPrice: '',
                              buyingPrice: '',
                              unitId: 2,
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
    _passwordController.dispose();
    super.dispose();
  }
}
