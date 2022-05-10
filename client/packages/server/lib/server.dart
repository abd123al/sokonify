import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';

class Server {
  static const MethodChannel _channel = MethodChannel('server');

  static Future<String?> startServer() async {
    if (Platform.isWindows) {
      call(int port) async {
        final DynamicLibrary lib = DynamicLibrary.open("lib.dll");
        final int Function(int) startServer = lib
            .lookup<NativeFunction<Int32 Function(Int32)>>('StartServer')
            .asFunction();

        final result = startServer(port);
        return "$result";
      }

      const port = 9090;
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
