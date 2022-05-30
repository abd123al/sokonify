import 'package:auto_size_text/auto_size_text.dart';
import 'package:blocitory/blocitory.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/helpers/currency_formatter.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/repositories.dart';
import 'create_order_payment_cubit.dart';
import 'payments_list_cubit.dart';

class CreatePaymentWidget extends StatefulWidget {
  const CreatePaymentWidget({
    required this.orderId,
    required this.amount,
    Key? key,
  }) : super(key: key);

  final int orderId;
  final String amount;

  @override
  State<StatefulWidget> createState() {
    return _CreateStorePageState();
  }
}

class _CreateStorePageState extends State<CreatePaymentWidget> {
  final _dController = TextEditingController();
  late PaymentMethod _method;

  @override
  void initState() {
    _method = PaymentMethod.cash;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).secondaryHeaderColor,
              child: Center(
                child: AutoSizeText(
                  formatCurrency(widget.amount),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            const Divider(),
            DropdownSearch<PaymentMethod>(
              items: PaymentMethod.values,
              onChanged: (i) {
                setState(() {
                  _method = i!;
                });
              },
              itemAsString: (i) => i!.name.toUpperCase(),
              showSearchBox: false,
              mode: Mode.MENU,
              selectedItem: _method,
              dropdownSearchDecoration: const InputDecoration(
                labelText: "Payment method",
                hintText: "Choose payment method used",
                border: OutlineInputBorder(),
              ),
            ),
            const Divider(),
            TextField(
              controller: _dController,
              keyboardType: TextInputType.text,
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'Comment (Optional)',
                hintText: 'Enter anything..',
                border: OutlineInputBorder(),
              ),
            ),
            const Expanded(child: SizedBox()),
            MutationBuilder<CreateOrderPayment$Mutation$Payment,
                CreateOrderPaymentCubit, PaymentRepository>(
              blocCreator: (r) => CreateOrderPaymentCubit(r),
              onSuccess: (context, data) {
                //1.
                //2.
                //3.
                BlocProvider.of<PaymentsListCubit>(context)
                    .addItem(Payments$Query$Payment.fromJson(data.toJson()));
              },
              pop: true,
              builder: (context, cubit) {
                return Button(
                  padding: EdgeInsets.zero,
                  callback: () {
                    cubit.submitOrderPayment(
                      OrderPaymentInput(
                        description: _dController.text,
                        orderId: widget.orderId,
                        method: PaymentMethod.cash,
                      ),
                    );
                  },
                  title: 'Submit Payment',
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
    _dController.dispose();
    super.dispose();
  }
}
