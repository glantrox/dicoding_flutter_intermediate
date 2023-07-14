import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_intermediate/core/models/auth_response.dart';

import 'package:submission_intermediate/core/static/strings.dart';
import 'package:submission_intermediate/core/utils/string.dart';

import '../models/user.dart';

class AuthRepository {
  final stateKey = AppString.stateKey;
  final String _baseUrl = AppString.baseUrl;

  Future<SharedPreferences> _sharedPref() async {
    return await SharedPreferences.getInstance();
  }

  _delay() async {
    return await Future.delayed(const Duration(milliseconds: 1500));
  }

  isLoggedIn() async {
    final pref = await _sharedPref();
    await _delay();
    return pref.getBool(stateKey);
  }

  setLoggedIn() async {
    final pref = await _sharedPref();
    return pref.setBool(stateKey, true);
  }

  setLoggedOut() async {
    final pref = await _sharedPref();
    return pref.setBool(stateKey, false);
  }

  clearToken() async {
    final pref = await _sharedPref();
    return pref.setString(AppString.tokenKey, "");
  }

  // O=========================================================================>
  // ? POST : Login User //
  // <=========================================================================O

  Future<AuthResponse> loginUser(User user) async {
    String email = "${user.email}";
    String password = toMD5("${user.password}");
    Map<String, String> body = {
      "email": email,
      "password": password,
    };
    await _delay();
    try {
      final response = await post(Uri.parse('$_baseUrl/login'), body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var body = AuthResponse.fromJson(response.body);
        return body;
      } else {
        var error =
            AuthResponse.fromMap(jsonDecode(response.body)).message.toString();

        throw error;
      }
    } on AuthResponse catch (e) {
      debugPrint('LOGIN USER ERROR');
      throw Exception('Terjadi Kesalahan Server : $e');
    }
  }

  // O=========================================================================>
  // ? POST : Register
  // <=========================================================================O

  Future<AuthResponse> registerUser(User user) async {
    String name = "${user.name}";
    String email = "${user.email}";
    String password = toMD5("${user.password}");

    Map<String, dynamic> field = {
      "name": name,
      "email": email,
      "password": password,
    };
    await _delay();
    try {
      final response = await post(Uri.parse('$_baseUrl/register'), body: field);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var decoder = jsonDecode(response.body);
        var body = AuthResponse.fromMap(decoder);
        return body;
      } else {
        var error =
            AuthResponse.fromMap(jsonDecode(response.body)).message.toString();
        throw error;
      }
    } on AuthResponse catch (e) {
      throw Exception('Terjadi Kesalahan Server : $e');
    }
  }
}
