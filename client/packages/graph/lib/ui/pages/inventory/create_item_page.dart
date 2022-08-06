import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gql/generated/graphql_api.graphql.dart';
import 'item_form.dart';
import 'prices_cubit.dart';

class CreateItemPage extends StatelessWidget {
  const CreateItemPage({
    Key? key,
    required this.pricing,
  }) : super(key: key);

  final Categories$Query$Category pricing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Stock"),
      ),
      body: BlocProvider(
        create: (context) {
          return NewPriceCubit();
        },
        child: ItemForm<NewPriceCubit>(
          item: null,
          id: null,
          pricing: pricing,
        ),
      ),
    );
  }
}
