import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

import '../gql/client.dart';
import '../ui/widgets/graphql_client_builder.dart';

/// Sometimes we want different behaviours for different apps
startApp({
  required UrlHandler urlHandler,
  required StatusHandler statusHandler,
}) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: const Size(1200, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } catch (_) {}

  await Future.wait([
    Hive.initFlutter(),
  ]);

  runApp(
    Phoenix(
      child: GraphqlClientBuilder(
        urlHandler: urlHandler,
        statusHandler: statusHandler,
      ),
    ),
  );
}
