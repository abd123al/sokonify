import 'package:flutter/material.dart';

import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserBuilder(
        builder: (context, user) {
          final List<Widget> children = [
            ShortDetailTile(
              subtitle: "Email",
              value: user.email,
            ),
            ShortDetailTile(
              subtitle: "Username",
              value: user.username,
            ),
            ShortDetailTile(
              subtitle: "Phone",
              value: user.phone,
            ),
            const SizedBox(height: 16),
            const ListTile(
              title: Text("Change Password"),
              trailing: Icon(Icons.password),
            ),
          ];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                pinned: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(user.name),
                  // background: Image.asset(
                  //   'assets/images/beach.png',
                  //   fit: BoxFit.fill,
                  // ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      redirectTo(
                        context,
                        Routes.editProfile,
                        replace: true,
                      );
                    },
                    icon: const Icon(Icons.edit),
                  )
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return children[index];
                  },
                  childCount: children.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
