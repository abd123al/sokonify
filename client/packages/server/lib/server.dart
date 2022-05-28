import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Server {
  static const MethodChannel _channel = MethodChannel('server');

  static Future<String?> startServer() async {
    if (Platform.isWindows) {
      call(int port) async {
        final DynamicLibrary lib = DynamicLibrary.open("lib.dll");
        final int Function(int, bool) startServer = lib
            .lookup<NativeFunction<Int32 Function(Int32, Bool)>>('StartServer')
            .asFunction();

        //kReleaseMode will help deciding which db to use.
        final result = startServer(port, kReleaseMode);
        return "$result";
      }

      const port = kReleaseMode ? 8081 : 9091;
      Isolate.spawn(call, port);

      return "$port";
    } else {
      try {
        final String? port = await _channel.invokeMethod('startServer');
        return port;
      } catch (e) {
        log('startServer error: ${e.toString()}');
        return null;
      }
    }
  }

  static Future<bool> checkServerStatus(String endpoint) async {
    final dio = Dio();

    // Add the interceptor with optional options
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: print, // specify log function
        retries: 5, // retry count
        retryDelays: const [
          Duration(seconds: 1), // wait 1 sec before first retry
          Duration(seconds: 2), // wait 2 sec before second retry
          Duration(seconds: 5), // wait 3 sec before third retry
          Duration(seconds: 10),
          Duration(seconds: 15),
        ],
      ),
    );

    /// Sending a failing request for 5 times with a 1s, then 2s, then 3s interval
    final result = await dio.get(endpoint);

    return result.statusCode == 200;
  }
}
