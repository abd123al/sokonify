import 'package:fluro/fluro.dart';

import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String createBrand = "/createBrand";
  static String createCategory = "/createCategory";
  static String createCustomer = "/createCustomer";
  static String createExpense = "/createExpense";
  static String createGains = "/createGains";
  static String createExpensePayment = "/createExpensePayment";
  static String createCustomPayment = "/createCustomPayment";
  static String createItem = "/createItem";
  static String createOrder = "/createOrder";
  static String createProduct = "/createProduct";
  static String createSales = "/createSales";
  static String createStore = "/createStore";
  static String createUnit = "/createUnit";

  static String editCategory = "/editCategory";
  static String editProduct = "/editProduct";

  static String brands = "/brands";
  static String categories = "/categories";
  static String category = "/category";
  static String expenses = "/expenses";
  static String item = "/item";
  static String gains = "/gains";
  static String order = "/order";
  static String payment = "/payment";
  static String products = "/products";
  static String product = "/product";
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
      createBrand,
      handler: createBrandPagePageRouterHandler,
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
      createExpense,
      handler: createExpensePageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      createGains,
      handler: createGainsPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      createExpensePayment,
      handler: trackExpensePagePageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      createCustomPayment,
      handler: trackCustomPaymentPagePageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      createItem,
      handler: createItemRouterHandler,
      transitionType: TransitionType.materialFullScreenDialog,
    );

    router.define(
      createOrder,
      handler: createOrderPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      createSales,
      handler: createSalePageRouterHandler,
      transitionType: TransitionType.inFromLeft,
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
      "$editCategory/:id",
      handler: editCategoryPageRouterHandler,
      transitionType: TransitionType.nativeModal,
    );

    router.define(
      "$editProduct/:id",
      handler: editProductPageRouterHandler,
      transitionType: TransitionType.nativeModal,
    );

    router.define(
      brands,
      handler: brandsPagePageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      expenses,
      handler: expensesListPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      gains,
      handler: gainsListPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      "$category/:id",
      handler: categoryPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      "$item/:id",
      handler: itemPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      "$payment/:id",
      handler: paymentPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      products,
      handler: productsListRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      "$product/:id",
      handler: productPageRouterHandler,
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
  }
}
