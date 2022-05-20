import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/searchable_list.dart';
import 'customer_tile.dart';
import 'customers_list_cubit.dart';

class CustomersList extends StatelessWidget {
  const CustomersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Customers$Query$Customer>,
        CustomersListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, data, _) {
        return SearchableList<Customers$Query$Customer>(
          hintName: "Customer",
          list: data.items,
          compare: (i) => i.name,
          builder: (context, c) {
            return CustomerTile(customer: c);
          },
        );
      },
    );
  }
}
