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

var createCategoryRouterHandler = Handler(handlerFunc: (context, __) {
  return CreateCategoryPage(
    type: context?.settings?.arguments as CategoryType,
  );
});

var categoriesListRouterHandler = Handler(handlerFunc: (context, __) {
  return CategoriesListPage(
    type: context?.settings?.arguments as CategoryType,
  );
});

var createItemRouterHandler = Handler(handlerFunc: (context, __) {
  return CreateItemPage(
    pricing: context?.settings?.arguments as Categories$Query$Category,
  );
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
  final word = params["word"]![0].toString();

  return PaymentPage(
    id: int.parse(id),
    word: word,
  );
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

var editOrderPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];
  return EditOrderPage(id: int.parse(id));
});

var customerPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];
  return CustomerPage(id: int.parse(id));
});

var editCustomerPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];
  return EditCustomerPage(id: int.parse(id));
});

var createPaymentPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["orderId"]![0];
  final amount = params["amount"]![0];

  return CreatePaymentPage(
    orderId: int.parse(id),
    amount: amount,
  );
});

var statsPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const StatsPage();
});

var ordersPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const OrdersPaginatedPage();
});

var settingsPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const SettingsPage();
});

var editUserPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const EditUserPage();
});

var changePassPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const ChangePasswordPage();
});

var paymentsPageRouterHandler = Handler(handlerFunc: (context, params) {
  final word = params["word"]![0];

  return PaymentsPaginatedPage(
    word: word,
    type: context?.settings?.arguments as PaymentType,
  );
});
