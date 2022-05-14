import 'package:fluro/fluro.dart';

import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String createItem = "/createItem";
  static String createStore = "/createStore";
  static String createUnit = "/createUnit";
  static String units = "/units";

  /// [:params] should be defined here.
  static void configureRoutes(FluroRouter router) {
    // router.notFoundHandler = Handler(handlerFunc: (_, __) {
    //   return NotFound();
    // });

    router.define(root, handler: rootHandler);

    router.define(
      createItem,
      handler: createItemRouterHandler,
      transitionType: TransitionType.materialFullScreenDialog,
    );

    router.define(
      createStore,
      handler: createStoreRouterHandler,
      transitionType: TransitionType.materialFullScreenDialog,
    );

    router.define(
      createUnit,
      handler: createUnitRouterHandler,
      transitionType: TransitionType.materialFullScreenDialog,
    );

    router.define(
      units,
      handler: unitsListPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );
  }
}
