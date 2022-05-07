import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:graph/gql/token_box.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../utils/consts.dart';

Future<GraphQLClient> graphQLClient(String baseUrl) async {
  final dio = Dio(
    BaseOptions(
      connectTimeout: baseUrl.contains('https') ? 30000 : 10000,
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  final box = await tokenBox();

  final AuthLink _authLink = AuthLink(
    getToken: () {
      final token = box.get(tokenHiveKey);
      print('token $token');

      if (token != null) {
        return 'Bearer $token';
      }

      return null;
    },
  );

  final _errorLink = ErrorLink(
    onException: (
      Request request,
      NextLink forward,
      LinkException exception,
    ) async* {
      if (exception is HttpLinkServerException &&
          exception.response.statusCode == 401) {
        // BlocProvider.of<AuthStateCubit>(
        //     Application.navigatorKey.currentContext!)
        //     .logout();
        //
        // Phoenix.rebirth(Application.navigatorKey.currentContext!);
      }

      yield* forward(request);
    },
  );

  final Link _dioLink = DioLink(
    baseUrl,
    client: dio,
  );

  final Link _link = _authLink.concat(_errorLink).concat(_dioLink);

  return GraphQLClient(
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      query: Policies(
        fetch: FetchPolicy.noCache, //so refresh works
      ),
    ),
    link: _link,
  );
}
