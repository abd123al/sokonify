import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../ui/app.dart';
import '../gql/client.dart';

/// Sometimes we want different behaviours for different apps
startApp(String url) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Future.wait([
    Hive.initFlutter(),
  ]);

  runApp(
    Phoenix(
      child: FutureBuilder<GraphQLClient>(
        future: graphQLClient(url),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            /// Remove splash
            //FlutterNativeSplash.remove();

            return Provider<GraphQLClient>(
              create: (_) => snapshot.data!,
              child: const App(),
            );
          }

          return Container(
            color: Colors.teal,
          );
        },
      ),
    ),
  );
}
