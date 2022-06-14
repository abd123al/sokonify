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
        title: const Text("New Facility"),
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
  final _nameController = TextEditingController();
  final _tinController = TextEditingController();
  final _descController = TextEditingController();
  final _termsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final children = [
      if (widget.message != null)
        Text(
          widget.message!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      TextField(
        autofocus: true,
        controller: _nameController,
        keyboardType: TextInputType.text,
        maxLength: 50,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Facility Name',
          hintText: 'Enter your facility here',
          helperText: "Eg Sokonify Pharmacy, Mwanana Shop.",
        ),
      ),
      TextField(
        autofocus: true,
        controller: _tinController,
        keyboardType: TextInputType.text,
        maxLength: 30,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Tax Identification Number - TIN (Optional)',
          hintText: 'Enter your facility here',
          helperText: "Eg 123-456-789.",
        ),
      ),
      TextField(
        controller: _descController,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        maxLength: 200,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Facility Description (Optional)',
          hintText: 'Example\n'
              'P.O Box 4039 \n'
              'Mwanza Tanzania\n'
              'Phones: 0712 123456, 0712 654321\n'
              'Email: duka@example.com',
          helperText:
              "This will appear in printed invoice below Facility Name.",
        ),
      ),
      TextField(
        controller: _termsController,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        maxLength: 200,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Facility Terms & Conditions (Optional)',
          hintText: '1. Make sure your items matches this invoice.\n'
              '2. Once delivered items will not be accepted back.\n',
          helperText: "This will appear at the bottom of printed pages.",
        ),
      ),
      MutationBuilder<CreateStore$Mutation$Store, CreateStoreCubit,
          StoreRepository>(
        blocCreator: (r) => CreateStoreCubit(r),
        onSuccess: widget.onSuccess ??
            (context, data) {
              BlocProvider.of<StoresListCubit>(context)
                  .addItem(Stores$Query$Store.fromJson(data.toJson()));
            },
        pop: widget.onSuccess == null,
        builder: (context, cubit) {
          return Button(
            padding: EdgeInsets.zero,
            callback: () {
              cubit.submit(
                StoreInput(
                  name: _nameController.text,
                  tin: _tinController.text,
                  description: _descController.text,
                  terms: _termsController.text,
                  businessType: BusinessType.both,
                  storeType: StoreType.pharmacy,
                ),
              );
            },
            title: 'Submit',
          );
        },
      ),
    ];
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return children[index];
          },
          itemCount: children.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tinController.dispose();
    _descController.dispose();
    _termsController.dispose();
    super.dispose();
  }
}
