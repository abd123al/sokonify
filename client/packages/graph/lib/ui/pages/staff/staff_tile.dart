import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/redirect_to.dart';
import '../../../nav/routes.dart';

class StaffTile extends StatelessWidget {
  const StaffTile({
    Key? key,
    required this.staff,
    this.color,
  }) : super(key: key);

  final Staffs$Query$Staff staff;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(staff.user.name.substring(0,1)),
        ),
        title: Text(
          staff.user.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        onTap: () {
          //redirectTo(context, "${Routes.staff}/${staff.id}");
        },
      ),
    );
  }
}
