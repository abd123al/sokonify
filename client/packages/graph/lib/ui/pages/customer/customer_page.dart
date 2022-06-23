import 'package:flutter/material.dart';

import '../../../nav/nav.dart';
import '../../widgets/widgets.dart';
import 'customer_wrapper.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(
        label: "Customer",
        onPressed: () {
          redirectTo(
            context,
            "${Routes.editCustomer}/$id",
            replace: true,
          );
        },
      ),
      body: CustomerWrapper(
        id: id,
        builder: (context, store) {
          return DetailsList(
            children: [
              ShortDetailTile(
                subtitle: "Name",
                value: store.name,
              ),
              ShortDetailTile(
                subtitle: "Address",
                value: store.address,
              ),
              ShortDetailTile(
                subtitle: "Phone",
                value: store.phone,
              ),
              ShortDetailTile(
                subtitle: "Email",
                value: store.email,
              ),
              ShortDetailTile(
                subtitle: "TIN",
                value: store.tin,
              ),
              ShortDetailTile(
                subtitle: "Comment",
                value: store.comment,
              ),
            ],
          );
        },
      ),
    );
  }
}
