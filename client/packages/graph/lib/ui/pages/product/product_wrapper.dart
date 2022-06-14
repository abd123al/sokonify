import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/product_repository.dart';
import 'product_page_cubit.dart';

/// There is no need at all to edit posted order.
class ProductWrapper extends StatelessWidget {
  const ProductWrapper({
    Key? key,
    required this.id,
    required this.builder,
  }) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Product$Query$Product) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProductPageCubit(
          RepositoryProvider.of<ProductRepository>(context),
        );
      },
      child: QueryBuilder<Product$Query$Product, ProductPageCubit>(
        retry: (cubit) => cubit.fetch(id),
        initializer: (cubit) => cubit.fetch(id),
        builder: (context, data, _) {
          return builder(context, data);
        },
      ),
    );
  }
}
