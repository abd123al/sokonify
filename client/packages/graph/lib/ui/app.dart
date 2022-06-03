import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/widgets/widgets.dart';

import '../nav/routes.dart';
import '../utils/application.dart';
import 'pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = FluroRouter();
    Routes.configureRoutes(router);

    Application.router = router;

    const isServer = bool.fromEnvironment(
      "IS_SERVER",
      defaultValue: false,
    );

    return MaterialApp(
      title: 'Sokonify',
      theme: ThemeData(
        primarySwatch: isServer ? Colors.blueGrey : Colors.blue,
      ),
      onGenerateRoute: Application.router?.generator,
      home: const AuthWrapper(
        child: HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
