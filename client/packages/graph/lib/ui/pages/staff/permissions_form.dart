import 'package:blocitory/blocitory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/searchable_dropdown.dart';
import 'set_permissions_wrapper.dart';

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
              helperText: "Select only appropriate permissions staff needs",
              onChangedMultiSelection: (item) => setState(() {
                _permissions = item;
              }),
              selectedItems: _permissions,
            ),
            const SizedBox(
              height: 8,
            ),
            SetPermissionsWrapper(
              builder: (context, cubit) {
                return Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    final input = PermissionsInput(
                      roleId: widget.id,
                      permissions: _permissions,
                    );

                    cubit.submit(input);
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
    super.dispose();
  }
}
