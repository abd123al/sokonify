import 'package:fluro/fluro.dart';

import '../ui/pages/pages.dart';

var rootHandler = Handler(handlerFunc: (_, __) {
  return const HomePage();
});

var createStoreRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateStorePage();
});

var createItemRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateItemPage();
});

var unitsListPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const UnitsListPage();
});

var createUnitRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateUnitPage();
});
