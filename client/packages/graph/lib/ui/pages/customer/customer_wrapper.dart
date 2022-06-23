import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/customer_repository.dart';
import 'customer_page_cubit.dart';

/// There is no need at all to edit posted order.
class CustomerWrapper extends StatelessWidget {
  const CustomerWrapper({
    Key? key,
    required this.id,
    required this.builder,
  }) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Customer$Query$Customer) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CustomerPageCubit(
          RepositoryProvider.of<CustomerRepository>(context),
        );
      },
      child: QueryBuilder<Customer$Query$Customer, CustomerPageCubit>(
        retry: (cubit) => cubit.fetch(id),
        initializer: (cubit) => cubit.fetch(id),
        builder: (context, data, _) {
          return builder(context, data);
        },
      ),
    );
  }
}
