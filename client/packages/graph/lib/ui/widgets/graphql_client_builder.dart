import 'package:blocitory/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:graph/ui/widgets/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../gql/client.dart';
import '../app.dart';

class GraphqlClientBuilder extends StatelessWidget {
  final UrlHandler handler;

  const GraphqlClientBuilder({
    Key? key,
    required this.handler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GraphQLClient>(
      future: graphQLClient(handler),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return UniBlocProvider(
            graphQLClient: snapshot.data!,
            child: const App(),
          );
        }

        return Container(
          color: Colors.blue,
          child: const LoadingIndicator(),
        );
      },
    );
  }
}
