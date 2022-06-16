import 'package:flutter/material.dart';

import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';

class StorePage extends StatelessWidget {
  const StorePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(
        label: "Store",
        onPressed: () {
          redirectTo(
            context,
            Routes.editStore,
          );
        },
      ),
      body: StoreBuilder(
        noBuilder: (context) => const SizedBox(),
        builder: (context, store) {
          return DetailsList(
            children: [
              ShortDetailTile(
                subtitle: "Store Name",
                value: store.name,
              ),
              ShortDetailTile(
                subtitle: "Description",
                value: store.description,
              ),
              ShortDetailTile(
                subtitle: "Tin",
                value: store.tin,
              ),
              ShortDetailTile(
                subtitle: "Terms",
                value: store.terms,
              ),
            ],
          );
        },
      ),
    );
  }
}
