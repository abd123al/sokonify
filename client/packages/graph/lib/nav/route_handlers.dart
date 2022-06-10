import 'package:fluro/fluro.dart';

import '../gql/generated/graphql_api.graphql.dart';
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

var createSalePageRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateOrderPage(
    isOrder: false,
  );
});

var createCustomerRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateCustomerPage();
});

var orderPageRouterHandler = Handler(handlerFunc: (_, params) {
  final id = params["id"]![0];
  return OrderPage(id: int.parse(id));
});

var createExpensePageRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateExpensesCategoryPage(type: ExpenseType.out);
});

var createGainsPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateExpensesCategoryPage(type: ExpenseType.kw$in);
});

var expensesListPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const ExpensesListPage(type: ExpenseType.out);
});

var gainsListPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const ExpensesListPage(type: ExpenseType.kw$in);
});

var trackExpensePagePageRouterHandler = Handler(handlerFunc: (_, __) {
  return const TrackExpensePage(
    type: ExpenseType.out,
  );
});

var trackCustomPaymentPagePageRouterHandler = Handler(handlerFunc: (_, __) {
  return const TrackExpensePage(
    type: ExpenseType.kw$in,
  );
});

var createBrandPagePageRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateBrandPage();
});

var brandsPagePageRouterHandler = Handler(handlerFunc: (_, __) {
  return const BrandsListPage();
});

var itemPageRouterHandler = Handler(handlerFunc: (_, params) {
  final id = params["id"]![0];
  return ItemPage(id: int.parse(id));
});

var productPageRouterHandler = Handler(handlerFunc: (_, params) {
  final id = params["id"]![0];
  return ProductPage(id: int.parse(id));
});
