import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/cubit.dart';
import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/store_repository.dart';

class CreateStorePage extends StatefulWidget {
  const CreateStorePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateStorePageState();
  }
}

class _CreateStorePageState extends State<CreateStorePage> {
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Store"),
      ),
      body: Card(
        elevation: 16,
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  autofocus: true,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Store name',
                    hintText: 'Enter your Shop name',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                MutationBuilder<CreateStore$Mutation$Store, CreateStoreCubit,
                    StoreRepository>(
                  blocCreator: (r) => CreateStoreCubit(r),
                  onSuccess: (context, data) {
                    BlocProvider.of<StoresListCubit>(context)
                        .addStore(Stores$Query$Store.fromJson(data.toJson()));
                  },
                  pop: true,
                  builder: (context, cubit) {
                    return Button(
                      padding: EdgeInsets.zero,
                      callback: () {
                        cubit.submit(
                          StoreInput(
                            name: passwordController.text,
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
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
