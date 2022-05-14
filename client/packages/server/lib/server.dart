import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

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
}
