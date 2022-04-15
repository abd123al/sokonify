import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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

  final Link _dioLink = DioLink(
    baseUrl,
    client: dio,
  );

  return GraphQLClient(
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      query: Policies(
        fetch: FetchPolicy.noCache, //so refresh works
      ),
    ),
    link: _dioLink,
  );
}
