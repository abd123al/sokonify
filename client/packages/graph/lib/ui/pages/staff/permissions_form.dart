import 'package:blocitory/blocitory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/searchable_dropdown.dart';

class PermissionsForm extends StatefulWidget {
  const PermissionsForm({
    Key? key,
    required this.id,
    required this.type,
    required this.permissions,
  }) : super(key: key);

  final int id;
  final CategoryType type;
  final ResourceListData<Permissions$Query$Permission> permissions;

  @override
  State<StatefulWidget> createState() {
    return _CreateProductPageState();
  }
}

class _CreateProductPageState extends State<PermissionsForm> {
  late List<PermissionType> _permissions;
  late List<Categories$Query$Category> _categories;

  @override
  void initState() {
    super.initState();
    _permissions = widget.permissions.items
        .where((e) => e.permission != null)
        .map((e) => e.permission!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SearchableDropdown<PermissionType>.multiSelection(
              asString: (i) => describeEnum(i),
              data: ResourceListData(
                items: PermissionType.values,
              ),
              labelText: "Permissions",
              builder: (context, e) {
                return ListTile(
                  title: Text(e.name),
                );
              },
              hintText: "Permissions",
              helperText: "Select only appropriate permissions",
              onChangedMultiSelection: (item) => setState(() {
                _permissions = item;
              }),
              selectedItems: _permissions,
            ),
            const SizedBox(
              height: 8,
            ),
            // MutationBuilder<CreateProduct$Mutation$Product, CreateProductCubit,
            //     ProductRepository>(
            //   blocCreator: (r) => CreateProductCubit(r),
            //   pop: true,
            //   builder: (context, cubit) {
            //     return Button(
            //       padding: EdgeInsets.zero,
            //       callback: () {
            //         final input = ProductInput(
            //           categories: _permissions.map((e) => e.id).toList(),
            //         );
            //
            //         if (isEdit) {
            //           cubit.edit(widget.id!, input);
            //         } else {
            //           cubit.create(input);
            //         }
            //       },
            //       title: 'Submit',
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
