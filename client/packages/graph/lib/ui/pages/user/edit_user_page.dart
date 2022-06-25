import 'package:flutter/material.dart';
import 'package:graph/ui/widgets/widgets.dart';

import 'user_form.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: UserBuilder(
        builder: (context, customer) {
          return UserForm(
            user: customer,
          );
        },
      ),
    );
  }
}
