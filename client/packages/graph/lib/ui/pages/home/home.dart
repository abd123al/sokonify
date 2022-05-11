import 'package:flutter/material.dart';
import 'package:graph/ui/pages/auth/auth.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../widgets/widgets.dart';
import '../pages.dart';
import 'drawer.dart';
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
    );
  }

  Widget _buildBody() {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            const POS(),
            const StoresPage(),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.blue,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
   return TitledBottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        _pageController.jumpToPage(index);
      },
      items: [
        TitledNavigationBarItem(
          title: const Text('POS'),
          icon: const Icon(Icons.point_of_sale_outlined),
        ),
        TitledNavigationBarItem(
          title: const Text('Orders'),
          icon: const Icon(Icons.shopping_cart),
        ),
        TitledNavigationBarItem(
          title: const Text('Inventory'),
          icon: const Icon(Icons.inventory_outlined),
        ),
        TitledNavigationBarItem(
          title: const Text('Expenses'),
          icon: const Icon(Icons.explicit_outlined),
        ),
        TitledNavigationBarItem(
          title: const Text('Settings'),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }
}
