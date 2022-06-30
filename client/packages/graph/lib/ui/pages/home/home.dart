import 'package:flutter/material.dart';
import 'package:graph/ui/pages/auth/auth.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';
import 'customers.dart';
import 'drawer.dart';
import 'expense.dart';
import 'inventory.dart';
import 'pos.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StoreBuilder(
          builder: (context, u) {
            return InkWell(
              child: Text(u.name),
              onTap: () {
                showModalBottomSheet(
                  elevation: 16.0,
                  context: context,
                  builder: (context) {
                    return const StoreSwitcher();
                  },
                );
              },
            );
          },
          noBuilder: (BuildContext ctx) {
            return const Text("Sokonify");
          },
          loadingWidget: const Text("Connecting..."),
          retryWidget: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_outlined),
            tooltip: 'Open QR Code Scanner',
            onPressed: () {},
          ),
        ],
      ),
      drawer: const SokonifyDrawer(),
      body: StoreBuilder(
        noBuilder: (BuildContext ctx) {
          return StoreSwitcher(
            builder: (context, cubit) {
              /// Here user will be switched to the new store on success.
              return CreateStoreWidget(
                message: "Seems like you are new here! Why don't you create "
                    "a new facility.",
                onSuccess: (context, store) {
                  cubit.switchStore(
                    SwitchStoreInput(
                      storeId: store.id,
                    ),
                  );
                },
              );
            },
          );
        },
        builder: (context, u) {
          return _buildBody();
        },
      ),
      bottomNavigationBar: StoreBuilder(
        noBuilder: (context) => const SizedBox(),
        builder: (context, _) {
          return OrientationLayoutBuilder(
            portrait: (context) => _buildBottomNav(true),
            landscape: (context) => _buildBottomNav(false),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    final List<Widget> list = [
      const POS(),
      const OrdersListScaffold(),
      const Inventory(),
      const Expenses(),
      const Customers(),
    ];

    return SizedBox.expand(
      child: IndexedStack(
        index: _currentIndex,
        children: list,
      ),
    );
  }

  Widget _buildBottomNav(bool reverse) {
    return Builder(
      builder: (context) {
        TextStyle? style;
        if (!reverse) {
          style = Theme.of(context).textTheme.titleLarge;
        }

        return TitledBottomNavigationBar(
          reverse: reverse,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: [
            TitledNavigationBarItem(
              title: Text('POS', style: style),
              icon: const Icon(Icons.point_of_sale_outlined),
            ),
            TitledNavigationBarItem(
              title: Text('Orders', style: style),
              icon: const Icon(Icons.shopping_cart),
            ),
            TitledNavigationBarItem(
              title: Text('Inventory', style: style),
              icon: const Icon(Icons.inventory_outlined),
            ),
            TitledNavigationBarItem(
              title: Text('Expenses', style: style),
              icon: const Icon(Icons.explicit_outlined),
            ),
            TitledNavigationBarItem(
              title: Text('Customers', style: style),
              icon: const Icon(Icons.people_outlined),
            ),
          ],
        );
      },
    );
  }
}
