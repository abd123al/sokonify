import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';

import '../../cubits/cubit.dart';
import '../../gql/generated/graphql_api.graphql.dart';

class StoresPage extends StatelessWidget {
  const StoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryBuilder<ResourceListData<Stores$Query$Store>, StoresListCubit>(
      retry: (cubit) => cubit.fetch(),
      builder: (context, stores, _) {
        return Scaffold(
          body: ListView.builder(
            itemBuilder: (context, index) {
              final store = stores.items[index];

              return Card(
                elevation: 16,
                child: ListTile(
                  title: Text(
                    store.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              );
            },
            itemCount: stores.items.length,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Add',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
