import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/unit_repository.dart';
import 'create_unit_cubit.dart';
import 'units_list_cubit.dart';

class CreateUnitPage extends StatelessWidget {
  const CreateUnitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Unit"),
      ),
      body: const CreateUnitWidget(),
    );
  }
}

///todo do weed need this or delete it??
class CreateUnitWidget extends StatefulWidget {
  const CreateUnitWidget({
    Key? key,
    this.message,
    this.onSuccess,
  }) : super(key: key);

  /// If users have no stores, they will be greeted by this msg
  /// which will aid them in creating new store.
  final String? message;

  /// When users have no default store we are going to switch to this
  /// one automatically
  final Function(BuildContext, CreateUnit$Mutation$Unit)? onSuccess;

  @override
  State<StatefulWidget> createState() {
    return _CreateUnitPageState();
  }
}

class _CreateUnitPageState extends State<CreateUnitWidget> {
  final _nameController = TextEditingController();

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
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Unit name',
                  hintText: 'Enter unit name',
                  helperText: "Something like tabs, bottles, boxes",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              MutationBuilder<CreateUnit$Mutation$Unit, CreateUnitCubit, UnitRepository>(
                blocCreator: (r) => CreateUnitCubit(r),
                onSuccess: widget.onSuccess ??
                    (context, data) {
                      BlocProvider.of<UnitsListCubit>(context).addUnit(Units$Query$Unit.fromJson(data.toJson()));
                    },
                pop: widget.onSuccess == null,
                builder: (context, cubit) {
                  return Button(
                    padding: EdgeInsets.zero,
                    callback: () {
                      cubit.submit(
                        UnitInput(
                          name: _nameController.text,
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
    _nameController.dispose();
    super.dispose();
  }
}
