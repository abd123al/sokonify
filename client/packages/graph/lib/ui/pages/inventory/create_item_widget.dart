import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/product_repository.dart';
import 'create_product_cubit.dart';
import 'products_list_cubit.dart';

class CreateProductWidget extends StatefulWidget {
  const CreateProductWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateProductPageState();
  }
}

class _CreateProductPageState extends State<CreateProductWidget> {
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                controller: passwordController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Facility name',
                  hintText: 'Enter your Shop name',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              MutationBuilder<ProductPartsMixin, CreateProductCubit,
                  ProductRepository>(
                blocCreator: (r) => CreateProductCubit(r),
                onSuccess: (context, data) {
                  BlocProvider.of<ProductsListCubit>(context).addProduct(data);
                },
                pop: true,
                builder: (context, cubit) {
                  return Button(
                    padding: EdgeInsets.zero,
                    callback: () {
                      cubit.submit(
                        ProductInput(unit: '', name: ''),
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
    passwordController.dispose();
    super.dispose();
  }
}
