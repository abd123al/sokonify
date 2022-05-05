import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Application {
  static FluroRouter? router;

  /// For navigation
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
