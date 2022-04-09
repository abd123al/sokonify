import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:server/server.dart';

void main() {
  const MethodChannel channel = MethodChannel('server');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('startServer', () async {
    expect(await Server.startServer(), '42');
  });
}
