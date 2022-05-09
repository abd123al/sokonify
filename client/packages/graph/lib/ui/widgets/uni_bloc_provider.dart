import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

import '../../repositories/repositories.dart';
import '../pages/store/stores_list_cubit.dart';
import 'auth_wrapper_cubit.dart';
import 'user_builder_cubit.dart';

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
        final userRepository = UserRepository(client);

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
            ],
            child: widget.child,
          ),
        );
      },
    );
  }
}
