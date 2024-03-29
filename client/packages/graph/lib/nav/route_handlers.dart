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
  final name = context?.settings?.arguments as String;

  return CustomerPage(
    id: int.parse(id),
    name: name,
  );
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

var statsPageRouterHandler = Handler(handlerFunc: (context, __) {
  final args = context?.settings?.arguments as StatsPageArgs?;

  return StatsPage(
    args: args,
  );
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

var convertStockPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const ConvertStockPage();
});

var changePassPageRouterHandler = Handler(handlerFunc: (_, __) {
  return const ChangePasswordPage();
});

var printPricingPageRouterHandler = Handler(handlerFunc: (context, params) {
  return PrintPriceListPage(
    pricing: context?.settings?.arguments as Categories$Query$Category,
  );
});

var printInventoryPageRouterHandler = Handler(handlerFunc: (context, params) {
  return PrintPriceListPage(
    pricing: context?.settings?.arguments as Categories$Query$Category,
    inventory: true,
  );
});

var createStaffRouterHandler = Handler(handlerFunc: (_, params) {
  final id = params["id"]![0];

  return CreateStaffPage(
    roleId: int.parse(id),
  );
});

var paymentsPageRouterHandler = Handler(handlerFunc: (context, params) {
  final word = params["word"]![0];

  return PaymentsPaginatedPage(
    word: word,
    type: context?.settings?.arguments as PaymentType,
  );
});

var rolePageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];

  return RolePage(
    id: int.parse(id),
    name: context?.settings?.arguments as String,
  );
});

var editPermissionsRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];
  final type = context?.settings?.arguments as CategoryType;

  if (type == CategoryType.pricing) {
    return EditStaffPricing(
      roleId: int.parse(id),
    );
  }

  return EditPermissions(
    roleId: int.parse(id),
    type: type,
  );
});

var printSalesPageRouterHandler = Handler(handlerFunc: (context, params) {
  final args = context?.settings?.arguments as StatsArgs;
  final word = params["word"]![0];

  return PrintSalesPage(
    args: args,
    word: word,
  );
});

var printDailyStatsPageRouterHandler = Handler(handlerFunc: (context, params) {
  final args = context?.settings?.arguments as StatsArgs;
  final word = params["word"]![0];

  return PrintDailyStatsPage(
    args: args,
    word: word,
  );
});

var brandPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];

  return BrandPage(
    id: int.parse(id),
  );
});

var editBrandPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];

  return EditBrandPage(
    id: int.parse(id),
  );
});

var unitPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];

  return UnitPage(
    id: int.parse(id),
  );
});

var editUnitPageRouterHandler = Handler(handlerFunc: (context, params) {
  final id = params["id"]![0];

  return EditUnitPage(
    id: int.parse(id),
  );
});
