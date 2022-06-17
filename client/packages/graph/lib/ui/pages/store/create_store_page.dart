import 'package:flutter/material.dart';
import 'package:graph/ui/pages/store/store_form.dart';

import '../../../gql/generated/graphql_api.graphql.dart';

class CreateStorePage extends StatelessWidget {
  const CreateStorePage({
    Key? key,
    this.message,
    this.onSuccess,
  }) : super(key: key);

  final String? message;
  final Function(BuildContext, CreateStore$Mutation$Store)? onSuccess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Facility"),
      ),
      body: const CreateStoreWidget(),
    );
  }
}

class CreateStoreWidget extends StatelessWidget {
  const CreateStoreWidget({
    Key? key,
    this.message,
    this.onSuccess,
  }) : super(key: key);

  /// If users have no stores, they will be greeted by this msg
  /// which will aid them in creating new store.
  final String? message;

  /// When users have no default store we are going to switch to this
  /// one automatically
  final Function(BuildContext, CreateStore$Mutation$Store)? onSuccess;

  @override
  Widget build(BuildContext context) {
    return StoreForm(
      store: null,
      message: message,
      onSuccess: onSuccess,
    );
  }
}