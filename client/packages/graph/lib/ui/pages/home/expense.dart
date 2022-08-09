import 'package:flutter/material.dart';
import 'package:graph/gql/generated/graphql_api.graphql.dart';

import '../../../nav/nav.dart';
import '../../widgets/fab.dart';
import '../payment/payments_list.dart';
import '../payment/payments_list_cubit.dart';

class Expenses extends StatelessWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const PaymentsList<ExpensesListCubit>(
        type: PaymentType.expense,
        topper: SizedBox(),
      ),
      floatingActionButton: Fab(
        route: Routes.createExpensePayment,
        title: "Track Expense",
        permission: PermissionType.createExpensePayment,
      ),
    );
  }
}
