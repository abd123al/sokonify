import 'package:graph/graph.dart';
import 'package:server/server.dart';

void main() async {
  await startApp(
    urlHandler: () async {
      final port = await Server.startServer();
      return "http://127.0.0.1:$port";
    },
    statusHandler: (endpoint) {
      return Server.checkServerStatus(endpoint);
    },
  );
}
