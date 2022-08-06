import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/staff_repository.dart';
import '../../widgets/searchable_dropdown.dart';
import '../category/categories_wrapper.dart';
import 'create_staff_cubit.dart';
import 'users_cubit.dart';

/// todo In here staff can be switched to another role
class StaffForm extends StatefulWidget {
  const StaffForm({
    Key? key,
    required this.staff,
    required this.userId,
    required this.roleId,
  }) : super(key: key);

  final Staffs$Query$Staff? staff;
  final int? userId;
  final int roleId;

  @override
  State<StatefulWidget> createState() {
    return _CreateStaffPageState();
  }
}

class _CreateStaffPageState extends State<StaffForm> {
  late int _roleId;
  int? _userId;

  late bool isEdit;

  @override
  void initState() {
    super.initState();
    _roleId = widget.roleId;
    isEdit = widget.staff != null && widget.userId != null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return UsersCubit(
          RepositoryProvider.of<StaffRepository>(context),
        );
      },
      child: _form(),
    );
  }

  Form _form() {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            QueryBuilder<ResourceListData<Users$Query$User>, UsersCubit>(
              retry: (cubit) => cubit.fetch(),
              initializer: (cubit) => cubit.fetch(),
              builder: (context, data, _) {
                return SearchableDropdown<Users$Query$User>(
                  asString: (i) => i.name.toLowerCase(),
                  data: data,
                  labelText: "Staff (Optional)",
                  hintText: "Select User",
                  helperText: "",
                  onChanged: (item) => setState(() {
                    _userId = item?.id;
                  }),
                  selectedItem: (e) => e.id == _userId,
                );
              },
            ),
            CategoriesWrapper(
              type: CategoryType.role,
              builder: (context, list) {
                return SearchableDropdown<Categories$Query$Category>(
                  asString: (i) => i.name,
                  data: list,
                  labelText: "Role Category",
                  hintText: "Role",
                  helperText: "Select role category",
                  onChanged: (item) => setState(() {
                    _userId = item?.id;
                  }),
                  selectedItem: (e) => e.id == _roleId,
                );
              },
            ),
            const SizedBox(
              height: 8,
            ),
            MutationBuilder<CreateStaff$Mutation$Staff, CreateStaffCubit,
                StaffRepository>(
              blocCreator: (r) => CreateStaffCubit(r),
              pop: true,
              builder: (context, cubit) {
                return Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    final input = StaffInput(
                      userId: _userId!,
                      roleId: _roleId,
                    );

                    if (isEdit) {
                      //cubit.edit(widget.id!, input);
                    } else {
                      cubit.create(input);
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
    super.dispose();
  }
}
