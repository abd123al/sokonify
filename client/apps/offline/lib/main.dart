import 'package:flutter/material.dart';
import 'package:graph/graph.dart';
import 'package:server/server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? port = await Server.startServer();
  await startApp("http://127.0.0.1:${port ??= "8080"}/graphql");
}
