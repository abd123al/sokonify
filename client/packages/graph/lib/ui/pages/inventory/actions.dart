import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../nav/nav.dart';
import 'items_list_cubit.dart';
import 'items_stats_cubit.dart';

class ItemsActions extends StatelessWidget {
  const ItemsActions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView(
        shrinkWrap: true,
        children: [
          TextButton(
            onPressed: () => redirectTo(
              context,
              Routes.convertStock,
              replace: true,
            ),
            child: const Text("Convert Stock"),
          ),
          TextButton(
            onPressed: () => redirectTo(
              context,
              Routes.convertStock,
              replace: true,
            ),
            child: const Text("Print Price List"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              BlocProvider.of<ItemsListCubit>(context).fetch();
              BlocProvider.of<ItemsStatsCubit>(context).fetch();
            },
            child: const Text("Refresh Inventory"),
          ),
          // TextButton(
          //   onPressed: () {},
          //   child: const Text("Help"),
          // ),
        ],
      ),
    );
  }
}
