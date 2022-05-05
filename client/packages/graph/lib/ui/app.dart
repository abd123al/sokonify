import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../nav/routes.dart';
import '../utils/application.dart';
import 'helpers/helpers.dart';
import 'pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = FluroRouter();
    Routes.configureRoutes(router);

    Application.router = router;

    return MaterialApp(
      title: 'Mahesabu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Application.router?.generator,
      home: const UniBlocProvider(
        child: HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
