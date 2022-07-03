import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graph/graph.dart';
import 'package:network_info_plus/network_info_plus.dart';

void main() async {
  await startApp(
    urlHandler: () async {
      Future<String> getBaseUrl() async {
        if (kReleaseMode) {
          if (!kIsWeb) {
            ip() async {
              try {
                //In web this don't work
                final info = NetworkInfo();
                final ip = await info.getWifiIP();
                return ip;
              } catch (e) {
                return null;
              }
            }

            final url = "http://${await ip() ?? "127.0.0.1"}:9191";

            return url;
          }

          return "http://127.0.0.1:9191";
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
      const baseUrl = String.fromEnvironment(
        "BASE_URL",
        defaultValue: "",
      );

      return baseUrl.isNotEmpty ? baseUrl : await getBaseUrl();
    },
    statusHandler: (endpoint) {
      return true;
    },
  );
}
