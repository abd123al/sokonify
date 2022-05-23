import 'package:fluro/fluro.dart';

import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String categories = "/categories";
  static String createCategory = "/createCategory";
  static String createCustomer = "/createCustomer";
  static String createItem = "/createItem";
  static String createOrder = "/createOrder";
  static String createProduct = "/createProduct";
  static String createStore = "/createStore";
  static String createUnit = "/createUnit";
  static String order = "/order";
  static String products = "/products";
  static String units = "/units";

  /// [:params] should be defined here.
  static void configureRoutes(FluroRouter router) {
    // router.notFoundHandler = Handler(handlerFunc: (_, __) {
    //   return NotFound();
    // });

    router.define(root, handler: rootHandler);

    router.define(
      categories,
      handler: categoriesListRouterHandler,
      transitionType: TransitionType.materialFullScreenDialog,
    );

    router.define(
      createCategory,
      handler: createCategoryRouterHandler,
      transitionType: TransitionType.materialFullScreenDialog,
    );

    router.define(
      createCustomer,
      handler: createCustomerRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      createItem,
      handler: createItemRouterHandler,
      transitionType: TransitionType.materialFullScreenDialog,
    );

    router.define(
      createProduct,
      handler: createProductRouterHandler,
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
      products,
      handler: productsListRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      "$order/:id",
      handler: orderPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      units,
      handler: unitsListPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      createOrder,
      handler: createOrderPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );
  }
}
