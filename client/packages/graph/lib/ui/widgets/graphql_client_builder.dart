import 'package:blocitory/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:graph/ui/widgets/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../gql/client.dart';
import '../app.dart';

class GraphqlClientBuilder extends StatelessWidget {
  final UrlHandler urlHandler;
  final StatusHandler statusHandler;
  final Function() onDone;

  const GraphqlClientBuilder({
    Key? key,
    required this.urlHandler,
    required this.statusHandler,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GraphQLClient>(
      future: graphQLClient(
        urlHandler: urlHandler,
        statusHandler: statusHandler,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //Remove splash screen
          onDone();

          return Phoenix(
            child: UniBlocProvider(
              graphQLClient: snapshot.data!,
              child: const App(),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Center(
              child: Text(
                snapshot.error.toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.red,
                    ),
              ),
            ),
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
