import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'user_builder_cubit.dart';

class UserBuilder extends StatelessWidget {
  const UserBuilder({
    Key? key,
    required this.builder,
    this.loadingWidget,
  }) : super(key: key);

  final Widget Function(BuildContext ctx, Me$Query$User user) builder;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<Me$Query$User, UserBuilderCubit>(
      retry: (cubit) => cubit.fetch(),
      loadingWidget: loadingWidget,
      builder: (context, user, _) {
        return builder(context, user);
      },
    );
  }
}
