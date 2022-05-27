import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../gql/client.dart';
import '../ui/widgets/graphql_client_builder.dart';

/// Sometimes we want different behaviours for different apps
startApp(UrlHandler urlHandler) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Future.wait([
    Hive.initFlutter(),
  ]);

  runApp(
    Phoenix(
      child: GraphqlClientBuilder(
        handler: urlHandler,
      ),
    ),
  );
}
