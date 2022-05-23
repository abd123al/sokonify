import 'package:fluro/fluro.dart';

import '../ui/pages/pages.dart';

var rootHandler = Handler(handlerFunc: (_, __) {
  return const HomePage();
});

var createStoreRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateStorePage();
});

var createCategoryRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateCategoryPage();
});

var categoriesListRouterHandler = Handler(handlerFunc: (_, __) {
  return const CategoriesListPage();
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

var createProductRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateProductPage();
});

var productsListRouterHandler = Handler(handlerFunc: (_, __) {
  return const ProductsListPage();
});

var createOrderPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateOrderPage();
});

var createCustomerRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateCustomerPage();
});

var orderPageRouterHandler = Handler(handlerFunc: (_, params) {
  final id = params["id"]![0];
  return  OrderPage(id: int.parse(id));
});