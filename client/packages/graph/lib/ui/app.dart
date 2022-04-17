import 'package:flutter/material.dart';

import 'helpers/helpers.dart';
import 'pages/pages.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahesabu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UniBlocProvider(
        child: HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
