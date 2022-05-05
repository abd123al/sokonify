import 'package:fluro/fluro.dart';

import '../ui/pages/pages.dart';

var rootHandler = Handler(handlerFunc: (_, __) {
  return const HomePage();
});

var createStoreRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateStorePage();
});

var loginRouterHandler = Handler(handlerFunc: (_, __) {
  return const LoginInPage();
});
