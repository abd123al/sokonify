import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/brand_repository.dart';
import 'brand_page_cubit.dart';

class BrandWrapper extends StatelessWidget {
  const BrandWrapper({
    Key? key,
    required this.id,
    required this.builder,
  }) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Brand$Query$Brand) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return BrandCubit(
          RepositoryProvider.of<BrandRepository>(context),
        );
      },
      child: QueryBuilder<Brand$Query$Brand, BrandCubit>(
        retry: (cubit) => cubit.fetch(id),
        initializer: (cubit) => cubit.fetch(id),
        builder: (context, data, _) {
          return builder(context, data);
        },
      ),
    );
  }
}
