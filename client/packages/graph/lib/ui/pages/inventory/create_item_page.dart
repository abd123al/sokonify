import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/item_repository.dart';
import 'create_item_cubit.dart';
import 'items_list_cubit.dart';

class CreateItemPage extends StatelessWidget {
  const CreateItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Item"),
      ),
      body: const CreateItemWidget(),
    );
  }
}

class CreateItemWidget extends StatefulWidget {
  const CreateItemWidget({
    Key? key,
    this.message,
    this.onSuccess,
  }) : super(key: key);

  /// If users have no stores, they will be greeted by this msg
  /// which will aid them in creating new store.
  final String? message;

  /// When users have no default store we are going to switch to this
  /// one automatically
  final Function(BuildContext, CreateItem$Mutation$Item)? onSuccess;

  @override
  State<StatefulWidget> createState() {
    return _CreateItemPageState();
  }
}

class _CreateItemPageState extends State<CreateItemWidget> {
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
              if (widget.message != null)
                Text(
                  widget.message!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              const Divider(),
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
              MutationBuilder<ItemPartsMixin, CreateItemCubit, ItemRepository>(
                blocCreator: (r) => CreateItemCubit(r),
                onSuccess: (context, data) {
                  BlocProvider.of<ItemsListCubit>(context).addItem(data);
                },
                pop: widget.onSuccess == null,
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
                          productId: 1,
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
    passwordController.dispose();
    super.dispose();
  }
}
