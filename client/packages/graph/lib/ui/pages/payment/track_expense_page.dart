import 'package:blocitory/blocitory.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/repositories.dart';
import '../expenses_category/expense_category.dart';
import 'payments_list_cubit.dart';
import 'track_expense_cubit.dart';

class TrackExpensePage extends StatefulWidget {
  const TrackExpensePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateStorePageState();
  }
}

class _CreateStorePageState extends State<TrackExpensePage> {
  final _dController = TextEditingController();
  final _amountController = TextEditingController();
  Expenses$Query$Expense? _expense;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Expense"),
      ),
      body: _build(),
    );
  }

  Widget _build() {
    return MutationBuilder<CreateExpensePayment$Mutation$Payment,
        TrackExpenseCubit, PaymentRepository>(
      blocCreator: (r) => TrackExpenseCubit(r),
      onSuccess: (context, data) {
        BlocProvider.of<PaymentsListCubit>(context)
            .addItem(Payments$Query$Payment.fromJson(data.toJson()));
      },
      pop: true,
      builder: (context, cubit) {
        return Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                QueryBuilder<ResourceListData<Expenses$Query$Expense>,
                    ExpensesCategoriesListCubit>(
                  retry: (cubit) => cubit.fetch(),
                  builder: (context, data, _) {
                    return DropdownSearch<Expenses$Query$Expense>(
                      showSearchBox: true,
                      itemAsString: (u) => u!.name,
                      filterFn: (i, query) {
                        return i!.name.toLowerCase().contains(query ?? "");
                      },
                      isFilteredOnline: false,
                      mode: Mode.MENU,
                      items: data.items,
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Select Expense Category",
                        hintText: "Type category name",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (item) => setState(() {
                        _expense = item!;
                      }),
                      selectedItem: _expense,
                      searchDelay: const Duration(milliseconds: 0),
                      popupItemBuilder: (_, i, __) =>
                          ExpenseCategoryTile(expense: i),
                      showClearButton: true,
                    );
                  },
                ),
                const Divider(),
                TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Amount Spent',
                    hintText: 'Enter amount spent',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Divider(),
                TextField(
                  controller: _dController,
                  keyboardType: TextInputType.multiline,
                  maxLength: 100,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Comment (Optional)',
                    hintText: 'Enter anything..',
                    border: OutlineInputBorder(),
                  ),
                ),
                Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    cubit.submitExpensePayment(
                      ExpensePaymentInput(
                        description: _dController.text,
                        method: PaymentMethod.cash,
                        expenseId: _expense!.id,
                        amount: _amountController.text,
                      ),
                    );
                  },
                  title: 'Submit Expense',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _dController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}