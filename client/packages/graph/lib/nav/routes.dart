import 'package:fluro/fluro.dart';

import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String createStore = "/createStore";
  static String login = "/login";

  /// [:params] should be defined here.
  static void configureRoutes(FluroRouter router) {
    // router.notFoundHandler = Handler(handlerFunc: (_, __) {
    //   return NotFound();
    // });

    router.define(root, handler: rootHandler);

    router.define(
      createStore,
      handler: createStoreRouterHandler,
      transitionType: TransitionType.materialFullScreenDialog,
    );

    router.define(
      login,
      handler: loginRouterHandler,
      transitionType: TransitionType.materialFullScreenDialog,
    );
  }
}
