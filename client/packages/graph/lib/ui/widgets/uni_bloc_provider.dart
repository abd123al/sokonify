import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/widgets/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

import '../../repositories/repositories.dart';
import '../pages/category/categories_list_cubit.dart';
import '../pages/home/stats/simple_stats_cubit.dart';
import '../pages/inventory/inventory.dart';
import '../pages/product/products_list_cubit.dart';
import '../pages/store/stores_list_cubit.dart';
import '../pages/unit/units_list_cubit.dart';

class UniBlocProvider extends StatefulWidget {
  final Widget child;

  const UniBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UniBlocProviderState();
  }
}

class UniBlocProviderState extends State<UniBlocProvider> {
  Future<void> checkForUpdate() async {
    if (!kIsWeb) {
      InAppUpdate.checkForUpdate().then((info) {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          InAppUpdate.performImmediateUpdate().then((_) {}).catchError((e) {});
        }
      }).catchError((e) {});
    }
  }

  @override
  void initState() {
    checkForUpdate().then((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildClient();
  }

  _buildClient() {
    return Builder(
      builder: (context) {
        final client = Provider.of<GraphQLClient>(context);

        final storeRepository = StoreRepository(client);
        final authRepository = AuthRepository(client);
        final categoryRepository = CategoryRepository(client);
        final userRepository = UserRepository(client);
        final statsRepository = StatsRepository(client);
        final itemRepository = ItemRepository(client);
        final productRepository = ProductRepository(client);
        final unitRepository = UnitRepository(client);

        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthWrapperCubit>(
              create: (context) => AuthWrapperCubit()..check(),
            ),
            BlocProvider<StoresListCubit>(
              create: (context) {
                return StoresListCubit(storeRepository)..fetch();
              },
            ),
            BlocProvider<UserBuilderCubit>(
              create: (context) {
                return UserBuilderCubit(userRepository)..fetch();
              },
            ),
            BlocProvider<StoreBuilderCubit>(
              create: (context) {
                return StoreBuilderCubit(storeRepository)..fetch();
              },
            ),
            BlocProvider<ProductsListCubit>(
              create: (context) {
                return ProductsListCubit(productRepository)..fetch();
              },
            ),
            BlocProvider<ItemsListCubit>(
              create: (context) {
                return ItemsListCubit(itemRepository)..fetch();
              },
            ),
            BlocProvider<SimpleStatsCubit>(
              create: (context) {
                return SimpleStatsCubit(statsRepository)..fetch();
              },
            ),
            BlocProvider<UnitsListCubit>(
              create: (context) {
                return UnitsListCubit(unitRepository)..fetch();
              },
            ),
            BlocProvider<CategoriesListCubit>(
              create: (context) {
                return CategoriesListCubit(categoryRepository)..fetch();
              },
            ),
          ],
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<AuthRepository>(
                create: (context) => authRepository,
              ),
              RepositoryProvider<StoreRepository>(
                create: (context) => storeRepository,
              ),
              RepositoryProvider<UserRepository>(
                create: (context) => userRepository,
              ),
              RepositoryProvider<ItemRepository>(
                create: (context) => itemRepository,
              ),
              RepositoryProvider<ProductRepository>(
                create: (context) => productRepository,
              ),
              RepositoryProvider<UnitRepository>(
                create: (context) => unitRepository,
              ),
              RepositoryProvider<CategoryRepository>(
                create: (context) => categoryRepository,
              ),
            ],
            child: widget.child,
          ),
        );
      },
    );
  }
}
