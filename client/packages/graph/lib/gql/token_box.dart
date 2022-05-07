import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

/// This will be storing
Future<Box> tokenBox() async {
  const tokenKey = 'tokenKey';
  const secureStorage = FlutterSecureStorage();
  var thereIsKey = await secureStorage.containsKey(key: tokenKey);

  if (!thereIsKey) {
    var key = Hive.generateSecureKey();

    await secureStorage.write(
      key: tokenKey,
      value: base64UrlEncode(key),
    );
  }

  final rawKey = await secureStorage.read(key: tokenKey);
  var encryptionKey = base64Url.decode(rawKey!);

  final box = await Hive.openBox(
    'tokenVault',
    encryptionCipher: HiveAesCipher(encryptionKey),
  );

  return box;
}
