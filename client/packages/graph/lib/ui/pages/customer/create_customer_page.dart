import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/customer_repository.dart';
import 'create_customer_cubit.dart';
import 'customers_list_cubit.dart';

class CreateCustomerPage extends StatelessWidget {
  const CreateCustomerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Customer"),
      ),
      body: const CreateCustomerWidget(),
    );
  }
}

class CreateCustomerWidget extends StatefulWidget {
  const CreateCustomerWidget({
    Key? key,
    this.message,
    this.onSuccess,
  }) : super(key: key);

  /// If users have no stores, they will be greeted by this msg
  /// which will aid them in creating new store.
  final String? message;

  /// When users have no default store we are going to switch to this
  /// one automatically
  final Function(BuildContext, CreateCustomer$Mutation$Customer)? onSuccess;

  @override
  State<StatefulWidget> createState() {
    return _CreateCustomerPageState();
  }
}

class _CreateCustomerPageState extends State<CreateCustomerWidget> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (widget.message != null)
                Text(
                  widget.message!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              const Divider(),
              TextField(
                autofocus: true,
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Facility name',
                  hintText: 'Enter your Shop name',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              MutationBuilder<CreateCustomer$Mutation$Customer,
                  CreateCustomerCubit, CustomerRepository>(
                blocCreator: (r) => CreateCustomerCubit(r),
                onSuccess: (context, data) {
                  BlocProvider.of<CustomersListCubit>(context).addItem(
                      Customers$Query$Customer.fromJson(data.toJson()));
                },
                pop: widget.onSuccess == null,
                builder: (context, cubit) {
                  return Button(
                    padding: EdgeInsets.zero,
                    callback: () {
                      cubit.submit(
                        CustomerInput(
                          name: _nameController.text,
                          type: CustomerType.customer,
                        ),
                      );
                    },
                    title: 'Submit',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
