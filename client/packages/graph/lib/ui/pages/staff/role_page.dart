import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../category/category_page.dart';
import 'permissions.dart';
import 'staffs_list.dart';

class RoleTab {
  final Widget widget;
  final String title;

  RoleTab(this.title, this.widget);
}

class RolePage extends StatefulWidget {
  const RolePage({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);

  final int id;
  final String name;

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  late List<RoleTab> list;

  @override
  void initState() {
    super.initState();

    list = [
      RoleTab(
        "Staffs",
        StaffsList(roleId: widget.id),
      ),
      RoleTab(
        "Permissions",
        PermissionsWidget(id: widget.id, type: CategoryType.role),
      ),
      RoleTab(
        "Pricing",
        PermissionsWidget(id: widget.id, type: CategoryType.pricing),
      ),
      RoleTab(
        "Details",
        CategoryWidget(id: widget.id),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: list.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: list
                .map(
                  (e) => Tab(text: e.title),
                )
                .toList(),
          ),
          title: Text(widget.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit ${widget.name} Details',
              onPressed: () {
                redirectTo(
                  context,
                  "${Routes.editCategory}/${widget.id}",
                  replace: true,
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: list.map((e) => e.widget).toList(),
        ),
      ),
    );
  }
}
