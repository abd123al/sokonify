import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/store_repository.dart';
import 'create_store_cubit.dart';
import 'stores_list_cubit.dart';

class CreateStorePage extends StatelessWidget {
  const CreateStorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Store"),
      ),
      body: const CreateStoreWidget(),
    );
  }
}

class CreateStoreWidget extends StatefulWidget {
  const CreateStoreWidget({
    Key? key,
    this.message,
    this.onSuccess,
  }) : super(key: key);

  /// If users have no stores, they will be greeted by this msg
  /// which will aid them in creating new store.
  final String? message;

  /// When users have no default store we are going to switch to this
  /// one automatically
  final Function(BuildContext, CreateStore$Mutation$Store)? onSuccess;

  @override
  State<StatefulWidget> createState() {
    return _CreateStorePageState();
  }
}

class _CreateStorePageState extends State<CreateStoreWidget> {
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
              MutationBuilder<CreateStore$Mutation$Store, CreateStoreCubit,
                  StoreRepository>(
                blocCreator: (r) => CreateStoreCubit(r),
                onSuccess: widget.onSuccess ??
                    (context, data) {
                      BlocProvider.of<StoresListCubit>(context)
                          .addStore(Stores$Query$Store.fromJson(data.toJson()));
                    },
                pop: widget.onSuccess == null,
                builder: (context, cubit) {
                  return Button(
                    padding: EdgeInsets.zero,
                    callback: () {
                      cubit.submit(
                        StoreInput(
                          name: passwordController.text,
                          businessType: BusinessType.both,
                          storeType: StoreType.pharmacy,
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
