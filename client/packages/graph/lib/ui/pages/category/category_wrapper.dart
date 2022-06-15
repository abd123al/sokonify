import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/category_repository.dart';
import 'category_page_cubit.dart';

class CategoryWrapper extends StatelessWidget {
  const CategoryWrapper({
    Key? key,
    required this.id,
    required this.builder,
  }) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Category$Query$Category) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CategoryCubit(
          RepositoryProvider.of<CategoryRepository>(context),
        );
      },
      child: QueryBuilder<Category$Query$Category, CategoryCubit>(
        retry: (cubit) => cubit.fetch(id),
        initializer: (cubit) => cubit.fetch(id),
        builder: (context, data, _) {
          return builder(context, data);
        },
      ),
    );
  }
}
