import 'package:blocitory/helpers/resource_mutation_widget.dart';
import 'package:blocitory/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/widgets/widgets.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/user_repository.dart';
import 'change_password_cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordPageState();
  }
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: MutationBuilder<bool, ChangePasswordCubit, UserRepository>(
        blocCreator: (r) => ChangePasswordCubit(r),
        pop: true,
        builder: (context, cubit) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: FormList(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Current Password',
                    ),
                    controller: _currentController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Password',
                    ),
                    controller: _newController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (s) {
                      if ((s?.length ?? 0) < 8) {
                        return "New Password must contain at least 8 characters";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm New Password',
                    ),
                    controller: _confirmController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (s) {
                      if (s != _newController.text) {
                        return "Password don't match!";
                      }
                      return null;
                    },
                  ),
                  Button(
                    callback: () {
                      if (_formKey.currentState!.validate()) {
                        cubit.submit(
                          ChangePasswordInput(
                            newPassword: _newController.text,
                            currentPassword: _currentController.text,
                          ),
                        );
                      }
                    },
                    title: 'Submit',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();

    super.dispose();
  }
}
