import 'package:flutter/material.dart';

import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';
import 'store_wrapper.dart';

class StorePage extends StatelessWidget {
  const StorePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(
        label: "Facility",
        onPressed: () {
          redirectTo(
            context,
            Routes.editStore,
            replace: true,
          );
        },
      ),
      body: StoreWrapper(
        builder: (context, store) {
          return DetailsList(
            children: [
              ShortDetailTile(
                subtitle: "'Facility Name",
                value: store.name,
              ),
              ShortDetailTile(
                subtitle: "'Facility TIN",
                value: store.tin,
              ),
              ShortDetailTile(
                subtitle: "'Facility Description",
                value: store.description,
              ),
              ShortDetailTile(
                subtitle: "'Facility Terms & Conditions",
                value: store.terms,
              ),
            ],
          );
        },
      ),
    );
  }
}
