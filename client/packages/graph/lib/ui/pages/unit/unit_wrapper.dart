import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/unit_repository.dart';
import 'unit_page_cubit.dart';

class UnitWrapper extends StatelessWidget {
  const UnitWrapper({
    Key? key,
    required this.id,
    required this.builder,
  }) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Unit$Query$Unit) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return UnitCubit(
          RepositoryProvider.of<UnitRepository>(context),
        );
      },
      child: QueryBuilder<Unit$Query$Unit, UnitCubit>(
        retry: (cubit) => cubit.fetch(id),
        initializer: (cubit) => cubit.fetch(id),
        builder: (context, data, _) {
          return builder(context, data);
        },
      ),
    );
  }
}
