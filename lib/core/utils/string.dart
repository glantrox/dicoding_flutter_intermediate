import 'dart:convert';

import 'package:crypto/crypto.dart';

String toMD5(String value) {
  var key = utf8.encode(value);
  var hmacSha256 = Hmac(sha256, key);
  var digest = hmacSha256.convert(key);
  return digest.toString();
}

String toCapitalize(String value) {
  return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
}
