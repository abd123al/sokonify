import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/expense_repository.dart';
import 'create_expense_category_cubit.dart';
import 'expense_categories_list_cubit.dart';

class CreateExpensesCategoryPage extends StatefulWidget {
  const CreateExpensesCategoryPage({
    Key? key,
    required this.type,
  }) : super(key: key);
  final ExpenseType type;

  @override
  State<StatefulWidget> createState() {
    return _CreateExpensesCategoryPageState();
  }
}

class _CreateExpensesCategoryPageState
    extends State<CreateExpensesCategoryPage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Expenses Category"),
      ),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return MutationBuilder<CreateExpense$Mutation$Expense,
        CreateExpenseCategoryCubit, ExpenseRepository>(
      blocCreator: (r) => CreateExpenseCategoryCubit(r),
      onSuccess: (context, data) {
        BlocProvider.of<ExpensesCategoriesListCubit>(context)
            .addItem(Expenses$Query$Expense.fromJson(data.toJson()));
      },
      pop: true,
      builder: (context, cubit) {
        return Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Category name',
                    hintText: 'Enter category name',
                  ),
                ),
                Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    cubit.submit(
                      ExpenseInput(
                        name: _nameController.text,
                        type: widget.type,
                      ),
                    );
                  },
                  title: 'Submit',
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
    _nameController.dispose();
    super.dispose();
  }
}
