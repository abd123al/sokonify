import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:graph/gql/token_box.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../utils/application.dart';
import '../utils/consts.dart';

class AuthInterceptor extends Interceptor {
  final Box box;

  AuthInterceptor(this.box);

  @override
  Future onRequest(options, handler) async {
    final accessToken = await box.get(tokenHiveKey);

    if (accessToken == null) {
      return super.onRequest(options, handler);
    }
    options.headers["Authorization"] = "Bearer $accessToken";
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      //Instead of using cubit we just delete it here directly.
      await box.delete(tokenHiveKey);

      //Restart app.
      Phoenix.rebirth(Application.navigatorKey.currentContext!);
    }

    super.onError(err, handler);
  }
}

typedef UrlHandler = FutureOr<String> Function();

/// This will test if url is reachable
typedef StatusHandler = FutureOr<bool> Function(String address);

Future<GraphQLClient> graphQLClient({
  required UrlHandler urlHandler,
  required StatusHandler statusHandler,
}) async {
  final box = await tokenBox();
  final baseUrl = await urlHandler();

  final url = "$baseUrl/graphql";
  final statusUrl = "$baseUrl/status";

  /// This will delay graphql requests until everything is ready.
  final isLive = await statusHandler(statusUrl);

  if (!isLive) {
    throw Exception("Something went wrong please restart your app");
  }

  final dio = Dio(
    BaseOptions(
      connectTimeout: baseUrl.contains('https') ? 30000 : 10000,
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  dio.interceptors.add(AuthInterceptor(box));

  final Link dioLink = DioLink(
    url,
    client: dio,
  );

  return GraphQLClient(
    cache: GraphQLCache(),
    defaultPolicies: DefaultPolicies(
      query: Policies(
        fetch: FetchPolicy.noCache, //so refresh works
      ),
    ),
    link: dioLink,
  );
}
