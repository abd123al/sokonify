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
  static String createOrderPayment = "/createOrderPayment";
  static String createProduct = "/createProduct";
  static String createSales = "/createSales";
  static String createStore = "/createStore";
  static String createUnit = "/createUnit";

  static String editCategory = "/editCategory";
  static String editCustomer = "/editCustomer";
  static String editItem = "/editItem";
  static String editOrder = "/editOrder";
  static String editProduct = "/editProduct";
  static String editStore = "/editStore";

  static String brands = "/brands";
  static String categories = "/categories";
  static String category = "/category";
  static String customer = "/customer";
  static String expenses = "/expenses";
  static String item = "/item";
  static String gains = "/gains";
  static String order = "/order";
  static String orders = "/orders";
  static String payment = "/payment";
  static String payments = "/payments";
  static String products = "/products";
  static String product = "/product";
  static String settings = "/settings";
  static String stats = "/stats";
  static String store = "/store";
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
      "$createOrderPayment/:orderId/:amount",
      handler: createPaymentPageRouterHandler,
      transitionType: TransitionType.nativeModal,
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
      "$editCustomer/:id",
      handler: editCustomerPageRouterHandler,
      transitionType: TransitionType.nativeModal,
    );

    router.define(
      "$editItem/:id",
      handler: editItemPageRouterHandler,
      transitionType: TransitionType.nativeModal,
    );

    router.define(
      "$editOrder/:id",
      handler: editOrderPageRouterHandler,
      transitionType: TransitionType.nativeModal,
    );

    router.define(
      "$editProduct/:id",
      handler: editProductPageRouterHandler,
      transitionType: TransitionType.nativeModal,
    );

    router.define(
      editStore,
      handler: editStoreRouterHandler,
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
      "$customer/:id",
      handler: customerPageRouterHandler,
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
      stats,
      handler: statsPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      store,
      handler: storePagePageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      settings,
      handler: settingsPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      orders,
      handler: ordersPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      "$payments/:word",
      handler: paymentsPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );

    router.define(
      units,
      handler: unitsListPageRouterHandler,
      transitionType: TransitionType.inFromLeft,
    );
  }
}
