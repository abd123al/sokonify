import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/widgets/widgets.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/customer_repository.dart';
import 'create_customer_cubit.dart';
import 'customers_list_cubit.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({
    Key? key,
    required this.customer,
    required this.id,
  }) : super(key: key);

  final Customer$Query$Customer? customer;
  final int? id;

  @override
  State<StatefulWidget> createState() {
    return _CreateCustomerPageState();
  }
}

class _CreateCustomerPageState extends State<CustomerForm> {
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tinController = TextEditingController();

  late bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.customer != null && widget.id != null;

    _addressController.text = widget.customer?.address ?? "";
    _emailController.text = widget.customer?.email ?? "";
    _commentController.text = widget.customer?.comment ?? "";
    _nameController.text = widget.customer?.name ?? "";
    _phoneController.text = widget.customer?.phone ?? "";
    _tinController.text = widget.customer?.tin ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormList(
          children: [
            TextField(
              autofocus: true,
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: "Enter Customer's name",
                  helperText: "Example: Mwanana Pharmacy or John Doe"),
              maxLength: 20,
            ),
            TextField(
              controller: _addressController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address (Optional)',
                hintText: "Enter Customer's Address here",
                helperText: "Example: Bugarika-Msikitini, Mwanza",
              ),
              maxLength: 100,
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone (Optional)',
                hintText: "Enter Customer's Address here",
                helperText: "Example: 0745123456",
              ),
              maxLength: 20,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email (Optional)",
                hintText: "Enter Customer's Email here",
                helperText: "Example: s@sokonify.com",
              ),
              maxLength: 50,
            ),
            TextField(
              controller: _tinController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TIN (Optional)',
                hintText: "Enter Customer's Tax Identification number here",
                helperText: "Example: 100000-000",
              ),
              maxLength: 20,
            ),
            TextField(
              controller: _commentController,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Comment (Optional)',
                hintText: "Enter your comment here.",
                helperText: "Anything here...",
              ),
              maxLines: 3,
              maxLength: 200,
            ),
            MutationBuilder<CreateCustomer$Mutation$Customer,
                CreateCustomerCubit, CustomerRepository>(
              blocCreator: (r) => CreateCustomerCubit(r),
              onSuccess: (context, data) {
                if (isEdit) {
                  BlocProvider.of<CustomersListCubit>(context).updateItem(
                    (l) => l.firstWhere((e) => e.id == widget.id),
                    Customers$Query$Customer.fromJson(data.toJson()),
                  );
                } else {
                  BlocProvider.of<CustomersListCubit>(context).addItem(
                      Customers$Query$Customer.fromJson(data.toJson()));
                }
              },
              pop: true,
              builder: (context, cubit) {
                return Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    final input = CustomerInput(
                      address: _addressController.text,
                      comment: _commentController.text,
                      email: _emailController.text,
                      name: _nameController.text,
                      phone: _phoneController.text,
                      tin: _tinController.text,
                      type: CustomerType.customer,
                    );

                    if (isEdit) {
                      cubit.edit(EditCustomerArguments(
                        id: widget.id!,
                        input: input,
                      ));
                    } else {
                      cubit.create(input);
                    }
                  },
                  title: 'Submit',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _commentController.dispose();
    _phoneController.dispose();
    _tinController.dispose();
    super.dispose();
  }
}
