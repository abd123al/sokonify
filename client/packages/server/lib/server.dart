import 'dart:async';

import 'package:flutter/services.dart';

class Server {
  static const MethodChannel _channel = MethodChannel('server');

  static Future<String?> startServer() async {
    try {
      final String? port = await _channel.invokeMethod('startServer');
      return port;
    } catch (e) {
      return null;
    }
  }
}
