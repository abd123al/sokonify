import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:graph/ui/pages/auth/auth.dart';

import '../widgets/widgets.dart';
import 'pages.dart';

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
            tooltip: 'Open shopping cart',
            onPressed: () {
              BlocProvider.of<AuthWrapperCubit>(context).logOut();
              //Restart app.
              Phoenix.rebirth(context);
            },
          ),
        ],
      ),
      body: StoreBuilder(
        noBuilder: (BuildContext ctx) {
          return const Text("Sokonify");
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
    return BottomNavyBar(
      selectedIndex: _currentIndex,
      onItemSelected: (index) {
        setState(() => _currentIndex = index);
        _pageController.jumpToPage(index);
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
            title: const Text('Item One'), icon: const Icon(Icons.home)),
        BottomNavyBarItem(
            title: const Text('Item Two'), icon: const Icon(Icons.apps)),
        BottomNavyBarItem(
            title: const Text('Item Three'),
            icon: const Icon(Icons.chat_bubble)),
        BottomNavyBarItem(
            title: const Text('Item Four'), icon: const Icon(Icons.settings)),
      ],
    );
  }
}
