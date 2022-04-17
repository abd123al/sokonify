import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

import '../../cubits/cubit.dart';
import '../../repositories/repositories.dart';

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

        return MultiBlocProvider(
          providers: [
            BlocProvider<StoresListCubit>(
              create: (context) {
                return StoresListCubit(storeRepository)..fetch();
              },
            ),
          ],
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<StoreRepository>(
                create: (context) => storeRepository,
              ),
            ],
            child: widget.child,
          ),
        );
      },
    );
  }
}
