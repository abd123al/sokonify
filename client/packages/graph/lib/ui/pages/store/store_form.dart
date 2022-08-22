import 'package:blocitory/blocitory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/store_repository.dart';
import '../../widgets/widgets.dart';
import 'create_store_cubit.dart';
import 'stores_list_cubit.dart';

class StoreForm extends StatefulWidget {
  const StoreForm({
    Key? key,
    required this.store,
    this.message,
    this.onSuccess,
  }) : super(key: key);

  final CurrentStore$Query$Store? store;

  /// If users have no stores, they will be greeted by this msg
  /// which will aid them in creating new store.
  final String? message;

  /// When users have no default store we are going to switch to this
  /// one automatically
  final Function(BuildContext, CreateStore$Mutation$Store)? onSuccess;

  @override
  State<StatefulWidget> createState() {
    return _FormStoreState();
  }
}

class _FormStoreState extends State<StoreForm> {
  final _descController = TextEditingController();
  final _nameController = TextEditingController();
  final _termsController = TextEditingController();
  final _tinController = TextEditingController();
  late bool isEdit;
  late StoreType? _storeType;
  late BusinessType? _businessType;

  @override
  void initState() {
    super.initState();
    isEdit = widget.store != null;

    _descController.text = widget.store?.description ?? "";
    _nameController.text = widget.store?.name ?? "";
    _termsController.text = widget.store?.terms ?? "";
    _tinController.text = widget.store?.tin ?? "";

    _storeType = widget.store?.storeType ?? StoreType.pharmacy;
    _businessType = widget.store?.businessType ?? BusinessType.retail;
  }

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
      SearchableDropdown<StoreType>(
        asString: (i) => i.name.toUpperCase(),
        data: ResourceListData(
          items: StoreType.values, //todo remove unknown
        ),
        labelText: "Facility Type",
        hintText: "Select Facility Type",
        selectedItem: (e) => e == _storeType,
        onChanged: (p) => setState(() {
          _storeType = p;
        }),
      ),
      SearchableDropdown<BusinessType>(
        asString: (i) => i.name.toUpperCase(),
        data: ResourceListData(
          items: BusinessType.values, //todo remove unknown
        ),
        labelText: "Business Type",
        hintText: "Select Business Type",
        selectedItem: (e) => e == _businessType,
        onChanged: (p) => setState(() {
          _businessType = p;
        }),
      ),
      MutationBuilder<CreateStore$Mutation$Store, CreateStoreCubit,
          StoreRepository>(
        blocCreator: (r) => CreateStoreCubit(r),
        onSuccess: widget.onSuccess ??
            (context, data) {
              if (!isEdit) {
                BlocProvider.of<StoresListCubit>(context)
                    .addItem(Stores$Query$Store.fromJson(data.toJson()));
              } else {
                BlocProvider.of<StoresListCubit>(context).updateItem(
                  (l) => l.firstWhere((e) => e.id == widget.store?.id),
                  Stores$Query$Store.fromJson(data.toJson()),
                );
                BlocProvider.of<StoreBuilderCubit>(context).fetch();
                // todo
                // BlocProvider.of<StoreBuilderCubit>(context).update(
                //   CurrentStore$Query$Store.fromJson(data.toJson()),
                // );
              }
            },
        pop: widget.onSuccess == null,
        builder: (context, cubit) {
          return Button(
            padding: EdgeInsets.zero,
            callback: () {
              final input = StoreInput(
                name: _nameController.text,
                tin: _tinController.text,
                description: _descController.text,
                terms: _termsController.text,
                businessType: _businessType!,
                storeType: _storeType!,
              );

              if (!isEdit) {
                cubit.create(input);
              } else {
                cubit.edit(
                  widget.store!.id,
                  input,
                );
              }
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
