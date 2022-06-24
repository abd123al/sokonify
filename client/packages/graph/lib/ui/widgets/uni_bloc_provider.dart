import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/widgets/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../repositories/repositories.dart';
import '../pages/home/stats/simple_stats_cubit.dart';
import '../pages/inventory/items_stats_cubit.dart';
import '../pages/pages.dart';
import '../pages/store/stores_list_cubit.dart';

class UniBlocProvider extends StatefulWidget {
  final Widget child;
  final GraphQLClient graphQLClient;

  const UniBlocProvider({
    Key? key,
    required this.child,
    required this.graphQLClient,
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
        final client = widget.graphQLClient;

        final storeRepository = StoreRepository(client);
        final authRepository = AuthRepository(client);
        final brandRepository = BrandRepository(client);
        final expenseRepository = ExpenseRepository(client);
        final categoryRepository = CategoryRepository(client);
        final customerRepository = CustomerRepository(client);
        final userRepository = UserRepository(client);
        final statsRepository = StatsRepository(client);
        final itemRepository = ItemRepository(client);
        final productRepository = ProductRepository(client);
        final unitRepository = UnitRepository(client);
        final orderRepository = OrderRepository(client);
        final paymentRepository = PaymentRepository(client);

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthWrapperCubit()..check(),
            ),
            BlocProvider(
              create: (context) {
                return StoresListCubit(storeRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return BrandsListCubit(brandRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return UserBuilderCubit(userRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return StoreBuilderCubit(storeRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return ProductsListCubit(productRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return ItemsListCubit(itemRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return SimpleStatsCubit(statsRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return ItemsStatsCubit(statsRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return UnitsListCubit(unitRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return CategoriesListCubit(categoryRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return OrdersListCubit(orderRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return CustomersListCubit(customerRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return PaymentsListCubit(paymentRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return ExpensesCategoriesListCubit(expenseRepository)..fetch();
              },
            ),
            BlocProvider(
              create: (context) {
                return NewOrderCubit();
              },
            ),
          ],
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(create: (context) => authRepository),
              RepositoryProvider(create: (context) => brandRepository),
              RepositoryProvider(create: (context) => storeRepository),
              RepositoryProvider(create: (context) => userRepository),
              RepositoryProvider(create: (context) => itemRepository),
              RepositoryProvider(create: (context) => productRepository),
              RepositoryProvider(create: (context) => unitRepository),
              RepositoryProvider(create: (context) => categoryRepository),
              RepositoryProvider(create: (context) => orderRepository),
              RepositoryProvider(create: (context) => customerRepository),
              RepositoryProvider(create: (context) => paymentRepository),
              RepositoryProvider(create: (context) => expenseRepository),
              RepositoryProvider(create: (context) => statsRepository),
            ],
            child: widget.child,
          ),
        );
      },
    );
  }
}
