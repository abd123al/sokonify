import 'package:blocitory/blocitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graph/ui/pages/payment/payment_tile.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import '../../../repositories/payment_repository.dart';

class PaymentsPaginatedPage extends StatelessWidget {
  const PaymentsPaginatedPage({
    Key? key,
    required this.word,
    required this.type,
  }) : super(key: key);

  final String word;
  final PaymentType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: PaymentsPaginationList(
        by: PaymentsBy.store,
        type: type,
        word: word,
        value: null,
      ),
    );
  }
}

class PaymentsPaginationList extends StatelessWidget {
  const PaymentsPaginationList({
    Key? key,
    this.value,
    required this.by,
    required this.word,
    this.type = PaymentType.order,
  }) : super(key: key);

  final int? value;
  final PaymentsBy by;
  final String word;
  final PaymentType type;

  @override
  Widget build(BuildContext context) {
    return AutoPagedList<Payments$Query$Payment>(
      executor: (context, skip) {
        return RepositoryProvider.of<PaymentRepository>(context).fetchPayments(
          PaymentsArgs(
            offset: skip,
            limit: 10,
            mode: FetchMode.pagination,
            by: by,
            type: type,
            value: value,
          ),
        );
      },
      parser: (result) => Payments$Query.fromJson(result.data!).payments,
      widgetBuilder: (context, i) {
        return PaymentTile(
          payment: i,
          word: word,
        );
      },
    );
  }
}
