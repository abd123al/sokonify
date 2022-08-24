import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/unit/units_list_cubit.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/unit_repository.dart';
import '../../widgets/form_list.dart';
import 'create_unit_cubit.dart';

class UnitForm extends StatefulWidget {
  const UnitForm({
    Key? key,
    required this.brand,
    required this.id,
  }) : super(key: key);

  final Unit$Query$Unit? brand;
  final int? id;

  @override
  State<StatefulWidget> createState() {
    return _CreateUnitPageState();
  }
}

class _CreateUnitPageState extends State<UnitForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late bool isEdit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isEdit = widget.brand != null && widget.id != null;
    _nameController.text = widget.brand?.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormList(
          children: [
            TextFormField(
              autofocus: true,
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Unit name',
                hintText: 'Enter unit name',
                helperText: "Something like tabs, bottles, boxes",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter brand name';
                }
                return null;
              },
            ),
            MutationBuilder<CreateUnit$Mutation$Unit, CreateUnitCubit,
                UnitRepository>(
              blocCreator: (r) => CreateUnitCubit(r),
              onSuccess: (context, data) {
                if (isEdit) {
                  BlocProvider.of<UnitsListCubit>(context).updateItem(
                    (l) => l.firstWhere((e) => e.id == widget.id),
                    Units$Query$Unit.fromJson(data.toJson()),
                  );
                } else {
                  BlocProvider.of<UnitsListCubit>(context)
                      .addItem(Units$Query$Unit.fromJson(data.toJson()));
                }
              },
              pop: true,
              builder: (context, cubit) {
                return Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    if (_formKey.currentState!.validate()) {
                      final input = UnitInput(
                        name: _nameController.text,
                      );

                      if (isEdit) {
                        cubit.edit(EditUnitArguments(
                          input: input,
                          id: widget.id!,
                        ));
                      } else {
                        cubit.create(input);
                      }
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
    _descriptionController.dispose();
    super.dispose();
  }
}
