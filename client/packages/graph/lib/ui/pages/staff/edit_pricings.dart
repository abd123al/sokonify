import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'permissions_wrapper.dart';
import 'pricings_form.dart';

class EditStaffPricing extends StatelessWidget {
  const EditStaffPricing({
    Key? key,
    required this.roleId,
  }) : super(key: key);

  final int roleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Pricing Categories"),
      ),
      body: PermissionsWrapper(
        roleId: roleId,
        type: CategoryType.pricing,
        builder: (context, list, _) {
          List<int> pricingIds = [];

          for (var element in list.items) {
            if (element.pricing != null) {
              pricingIds.add(element.pricing!.id);
            }
          }

          return StaffPricingForm(
            id: roleId,
            pricingIds: pricingIds,
          );
        },
      ),
    );
  }
}
