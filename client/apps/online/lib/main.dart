import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graph/graph.dart';

void main() async {
  await startApp(() {
    String getBaseUrl() {
      if (kReleaseMode) {
        return "http://127.0.0.1:8081";
      } else {
        //Web don't support platform
        if (!kIsWeb) {
          if (Platform.isAndroid) {
            return "http://10.0.2.2:8080";
          }
        }
      }

      return "http://127.0.0.1:8080";
    }

    //This works for majority env
    String baseUrl = String.fromEnvironment(
      "BASE_URL",
      defaultValue: getBaseUrl(),
    );

    return "$baseUrl/graphql";
  });
}
