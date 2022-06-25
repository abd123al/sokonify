import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';

class SokonifyDrawer extends StatelessWidget {
  const SokonifyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      UserBuilder(
        builder: (context, data) {
          return UserAccountsDrawerHeader(
            accountEmail: Text(data.email),
            accountName: Text(data.name),
            // currentAccountPicture: CachedNetworkImage(
            //   imageUrl: "",
            //   placeholder: (__, _) => const CircularProgressIndicator(),
            //   errorWidget: (___, __, _) => const Icon(Icons.error),
            // ),
          );
        },
      ),
      StoreBuilder(
        noBuilder: (context) => const SizedBox(),
        builder: (context, _) {
          ///All these need someone to have store
          return Column(
            children: [
              ListTile(
                title: const Text('Facility'),
                trailing: const Icon(Icons.store),
                onTap: () {
                  redirectTo(context, Routes.store);
                },
              ),
              ListTile(
                title: const Text('Products'),
                trailing: const Icon(Icons.dashboard_outlined),
                onTap: () {
                  redirectTo(context, Routes.products);
                },
              ),
              ListTile(
                title: const Text('Units'),
                trailing: const Icon(Icons.brightness_1_rounded),
                onTap: () {
                  redirectTo(context, Routes.units);
                },
              ),
              ListTile(
                title: const Text('Brands'),
                trailing: const Icon(Icons.branding_watermark_outlined),
                onTap: () {
                  redirectTo(context, Routes.brands);
                },
              ),
              // const Divider(),
              // ListTile(
              //   title: const Text('Payment Categories'),
              //   trailing: const Icon(Icons.category_outlined),
              //   onTap: () {
              //     redirectTo(context, Routes.gains);
              //   },
              // ),
              const Divider(),
              ListTile(
                title: const Text('Product Categories'),
                trailing: const Icon(Icons.category_outlined),
                onTap: () {
                  redirectTo(context, Routes.categories);
                },
              ),
              ListTile(
                title: const Text('Expense Categories'),
                trailing: const Icon(Icons.category_outlined),
                onTap: () {
                  redirectTo(context, Routes.expenses);
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Staffs'),
                trailing: const Icon(Icons.people_outlined),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Stats'),
                trailing: const Icon(Icons.query_stats_outlined),
                onTap: () => redirectTo(context, Routes.stats),
              ),
              const Divider(),
              ListTile(
                title: const Text('Settings'),
                trailing: const Icon(Icons.settings),
                onTap: () => redirectTo(context, Routes.settings),
              ),
            ],
          );
        },
      ),
      // const Divider(),
      // ListTile(
      //   title: const Text('Help/Feedback'),
      //   trailing: const Icon(Icons.help),
      //   onTap: () {},
      // ),
      // ListTile(
      //   title: const Text('Join Telegram Group'),
      //   trailing: const Icon(Icons.link),
      //   onTap: () {
      //     _openURL('https://t.me/STG_app');
      //   },
      // ),
      // ListTile(
      //   title: const Text('About this app'),
      //   //subtitle: const Text("I would love to know my score."),
      //   trailing: const Icon(Icons.info),
      //   onTap: () {},
      // ),
      // ListTile(
      //   title: const Text('Rate this app'),
      //   //subtitle: const Text("I would love to know my score."),
      //   trailing: const Icon(Icons.star),
      //   onTap: () {
      //     _openURL(
      //         "https://play.google.com/store/apps/details?id=com.kateile.stg.plus");
      //   },
      // ),
      // ListTile(
      //   title: const Text('Share this app'),
      //   //subtitle: const Text("Share with your loved ones."),
      //   trailing: const Icon(Icons.share),
      //   onTap: () {
      //     Share.share(
      //       'Hey, I am using a new STG Pro App. Download it here\n'
      //       'https://play.google.com/store/apps/details?id=com.kateile.stg.plus',
      //     );
      //   },
      // ),
      const Divider(),
      ListTile(
        title: const Text(
          'Sign Out',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        trailing: const Icon(
          Icons.logout,
          color: Colors.red,
        ),
        onTap: () {
          BlocProvider.of<AuthWrapperCubit>(context).logOut();

          //Restart app.
          Phoenix.rebirth(context);
        },
      ),
      const SizedBox(height: 50)
    ];

    return Drawer(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        controller: ScrollController(),
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          return children[index];
        },
      ),
    );
  }

  _openURL(String link) async {
    await launchUrl(Uri.parse(link));
  }
}
