import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/widgets.dart';

class SokonifyDrawer extends StatelessWidget {
  const SokonifyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: <Widget>[
          UserBuilder(
            builder: (context, data) {
              return UserAccountsDrawerHeader(
                accountEmail: Text(data.email),
                accountName: Text(data.name),
                currentAccountPicture: CachedNetworkImage(
                  imageUrl: "",
                  placeholder: (__, _) => const CircularProgressIndicator(),
                  errorWidget: (___, __, _) => const Icon(Icons.error),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Help/Feedback'),
            trailing: const Icon(Icons.help),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Join Telegram Group'),
            trailing: const Icon(Icons.link),
            onTap: () {
              _openURL('https://t.me/STG_app');
            },
          ),
          ListTile(
            title: const Text('About this app'),
            //subtitle: const Text("I would love to know my score."),
            trailing: const Icon(Icons.info),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Rate this app'),
            //subtitle: const Text("I would love to know my score."),
            trailing: const Icon(Icons.star),
            onTap: () {
              _openURL(
                  "https://play.google.com/store/apps/details?id=com.kateile.stg.plus");
            },
          ),
          ListTile(
            title: const Text('Share this app'),
            //subtitle: const Text("Share with your loved ones."),
            trailing: const Icon(Icons.share),
            onTap: () {
              Share.share(
                'Hey, I am using a new STG Pro App. Download it here\n'
                'https://play.google.com/store/apps/details?id=com.kateile.stg.plus',
              );
            },
          ),
          const Divider(),
          UserBuilder(
            builder: (context, _) {
              return ListTile(
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
              );
            },
          ),
        ],
      ),
    );
  }

  _openURL(String link) async {
    await launchUrl(Uri.parse(link));
  }
}