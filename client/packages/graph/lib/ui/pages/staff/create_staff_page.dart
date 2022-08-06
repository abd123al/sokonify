import 'package:flutter/material.dart';

import 'staff_form.dart';

class CreateStaffPage extends StatelessWidget {
  const CreateStaffPage({
    Key? key,
    required this.roleId,
  }) : super(key: key);

  final int roleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Staff"),
      ),
      body: StaffForm(
        staff: null,
        userId: null,
        roleId: roleId,
      ),
    );
  }
}
