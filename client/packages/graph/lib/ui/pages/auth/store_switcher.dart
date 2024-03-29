import 'package:blocitory/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../nav/nav.dart';
import '../../../repositories/auth_repository.dart';
import '../../widgets/auth_wrapper_cubit.dart';
import '../../widgets/store_builder.dart';
import '../store/stores_list_cubit.dart';
import 'auth_cubit.dart';

class StoreSwitcher extends StatelessWidget {
  const StoreSwitcher({
    Key? key,
    this.builder,
  }) : super(key: key);

  /// Sometimes we wanna use something else as a switcher
  /// eg when user creates defaults store
  final Widget Function(BuildContext, LoginCubit)? builder;

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      noBuilder: (BuildContext ctx) {
        return const SizedBox();
      },
      builder: (context, current) {
        return QueryBuilder<ResourceListData<Stores$Query$Store>,
            StoresListCubit>(
          retry: (cubit) => cubit.fetch(),
          builder: (context, stores, _) {
            return MutationBuilder<AuthPartsMixin, LoginCubit, AuthRepository>(
              blocCreator: (r) => LoginCubit(r),
              onSuccess: (context, data) {
                BlocProvider.of<AuthWrapperCubit>(context).login(data);

                Navigator.pop(context);

                //Restart app.
                Phoenix.rebirth(context);
              },
              loadingWidget: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
              builder: (context, cubit) {
                if (builder != null) {
                  return builder!(context, cubit);
                }

                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "Please select the facility you want to switch to",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final store = stores.items[index];

                        final isCurrent = current.id == store.id;
                        return ListTile(
                          title: Text(
                            store.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: isCurrent
                              ? const Icon(Icons.verified)
                              : const Icon(Icons.arrow_forward_sharp),
                          onTap: () {
                            cubit.switchStore(
                              SwitchStoreInput(storeId: store.id),
                            );
                          },
                          enabled: !isCurrent,
                        );
                      },
                      itemCount: stores.items.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                    Center(
                      child: Text(
                        "or",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    TextButton(
                      child: const Text(
                        "Create New Facility",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        redirectTo(context, Routes.createStore);
                      },
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
