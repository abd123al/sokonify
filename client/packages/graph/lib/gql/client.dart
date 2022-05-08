import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:graph/gql/token_box.dart';
import 'package:graph/ui/pages/auth/auth_cubit.dart';
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
    options.headers["Authorization"] = "Bearer " + accessToken;
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      BlocProvider.of<AuthCubit>(Application.navigatorKey.currentContext!)
          .logOut();

      //Restart app.
      Phoenix.rebirth(Application.navigatorKey.currentContext!);
    }

    super.onError(err, handler);
  }
}

Future<GraphQLClient> graphQLClient(String baseUrl) async {
  final dio = Dio(
    BaseOptions(
      connectTimeout: baseUrl.contains('https') ? 30000 : 10000,
    ),
  );

  final box = await tokenBox();

  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: false,
        responseBody: false,
        requestHeader: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  dio.interceptors.add(AuthInterceptor(box));

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
