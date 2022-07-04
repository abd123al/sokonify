import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/widgets/widgets.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/user_repository.dart';

class UserForm extends StatefulWidget {
  const UserForm({
    Key? key,
    required this.user,
  }) : super(key: key);

  final Me$Query$User? user;

  @override
  State<StatefulWidget> createState() {
    return _CreateUserPageState();
  }
}

class _CreateUserPageState extends State<UserForm> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();

  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.user != null;

    _emailController.text = widget.user?.email ?? "";
    _nameController.text = widget.user?.name ?? "";
    _phoneController.text = widget.user?.phone ?? "";
    _usernameController.text = widget.user?.username ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormList(
          children: [
            TextField(
              autofocus: true,
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: "Enter User's name",
                  helperText: "Example: Mwanana Pharmacy or John Doe"),
              maxLength: 20,
            ),
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: "Enter User's name",
                  helperText: "Example: Mwanana Pharmacy or John Doe"),
              maxLength: 20,
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone (Optional)',
                hintText: "Enter User's Address here",
                helperText: "Example: 0745123456",
              ),
              maxLength: 20,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email (Optional)",
                hintText: "Enter User's Email here",
                helperText: "Example: s@sokonify.com",
              ),
              maxLength: 50,
            ),
            MutationBuilder<Me$Query$User, UserBuilderCubit, UserRepository>(
              blocCreator: (r) => UserBuilderCubit(r),
              pop: true,
              builder: (context, cubit) {
                return Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    final input = ProfileInput(
                      email: _emailController.text,
                      name: _nameController.text,
                      phone: _phoneController.text,
                      username: _usernameController.text,
                    );

                    if (isEdit) {
                      cubit.edit(input);
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
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
