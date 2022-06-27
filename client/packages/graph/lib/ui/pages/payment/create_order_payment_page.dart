import 'package:auto_size_text/auto_size_text.dart';
import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/repositories.dart';
import '../../widgets/widgets.dart';
import '../home/stats/simple_stats_cubit.dart';
import '../order/orders_list_cubit.dart';
import 'create_order_payment_cubit.dart';
import 'payments_list_cubit.dart';

class CreatePaymentPage extends StatefulWidget {
  const CreatePaymentPage({
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

class _CreateStorePageState extends State<CreatePaymentPage> {
  final _dController = TextEditingController();
  late PaymentMethod _method;

  @override
  void initState() {
    _method = PaymentMethod.cash;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Payment"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Container(
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: AutoSizeText(
                            widget.amount,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    SearchableDropdown<PaymentMethod>(
                      data: ResourceListData<PaymentMethod>(
                          items: PaymentMethod.values),
                      onChanged: (i) {
                        setState(() {
                          _method = i!;
                        });
                      },
                      asString: (i) => i.name.toUpperCase(),
                      selectedItem: (e) => e == _method,
                      labelText: "Payment method",
                      hintText: "Choose payment method used",
                      helperText: "Payment method",
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
                          helperText:
                              "Anything that will make you remember this payment."),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
              MutationBuilder<CreateOrderPayment$Mutation$Payment,
                  CreatePaymentCubit, PaymentRepository>(
                blocCreator: (r) => CreatePaymentCubit(r, () {
                  BlocProvider.of<SimpleStatsCubit>(context).fetch();
                }),
                onSuccess: (context, data) {
                  BlocProvider.of<ParentPaymentsListCubit>(context)
                      .addItem(Payments$Query$Payment.fromJson(data.toJson()));

                  BlocProvider.of<OrdersListCubit>(context)
                      .changeOrderStatus(widget.orderId, OrderStatus.completed);
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
      ),
    );
  }

  @override
  void dispose() {
    _dController.dispose();
    super.dispose();
  }
}
