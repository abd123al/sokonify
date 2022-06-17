import 'package:fluro/fluro.dart';

import '../gql/generated/graphql_api.graphql.dart';
import '../ui/pages/pages.dart';

var rootHandler = Handler(handlerFunc: (_, __) {
  return const HomePage();
});

var createStoreRouterHandler = Handler(handlerFunc: (_, __) {
  return const CreateStorePage();
});

var editStoreRouterHandler = Handler(handlerFunc: (_, __) {
  return const EditStorePage();
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

var storePagePageRouterHandler = Handler(handlerFunc: (_, __) {
  return const StorePage();
});

var itemPageRouterHandler = Handler(handlerFunc: (_, params) {
  final id = params["id"]![0];
  return ItemPage(id: int.parse(id));
});

var productPageRouterHandler = Handler(handlerFunc: (_, params) {
  final id = params["id"]![0];
  return ProductPage(id: int.parse(id));
});

var paymentPageRouterHandler = Handler(handlerFunc: (_, params) {
  final id = params["id"]![0];
  return PaymentPage(id: int.parse(id));
});

var editProductPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];
  return EditProductPage(id: int.parse(id));
});

var categoryPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];
  return CategoryPage(id: int.parse(id));
});

var editCategoryPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];
  return EditCategoryPage(id: int.parse(id));
});

var editItemPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];
  return EditItemPage(id: int.parse(id));
});
