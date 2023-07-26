import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:submission_intermediate/core/static/enum.dart';
import 'package:submission_intermediate/core/static/strings.dart';

import '../core/api/auth_repository.dart';
import '../core/models/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  AuthProvider(this.authRepository);

  final tokenKey = AppString.tokenKey;
  AuthState loginState = AuthState.init;
  AuthState registerState = AuthState.init;
  AuthState logoutState = AuthState.init;
  String currentError = "";

  bool isLoggedIn = false;

  // O=========================================================================>
  // ? Additional Functions
  // <=========================================================================O

  Future<SharedPreferences> _sharedPref() async {
    return await SharedPreferences.getInstance();
  }

  _setMessage(String? value) async {
    currentError = value ?? "Unknown";
    notifyListeners();
  }

  _setLoginState(AuthState value) async {
    loginState = value;
    notifyListeners();
  }

  _setRegisterState(AuthState value) async {
    registerState = value;
    notifyListeners();
  }

  _setDebugMessages(
    String property,
    String? clientException,
    String? apiException,
  ) {
    const pembatas =
        "\nO=========================================================================>\n";
    return debugPrint(
      '${pembatas}Debug Exception : $property\nClient Exception:\n${clientException!}',
    );
  }

  // O=========================================================================>
  // ? Login user
  // <=========================================================================O

  Future<bool> login(User user) async {
    _setLoginState(AuthState.loading);
    SharedPreferences pref = await _sharedPref();
    try {
      final repo = await authRepository.loginUser(user);
      if (repo.error == false) {
        // Saves token from response
        pref.setString(tokenKey, repo.loginResult?.token ?? "");
        await authRepository.setLoggedIn();
      } else {
        _setMessage(repo.message);
        _setLoginState(AuthState.error);
        return false;
      }
      isLoggedIn = await authRepository.isLoggedIn();
      _setLoginState(AuthState.init);
      return isLoggedIn;
    } catch (e) {
      _setDebugMessages('loginUser', e.toString(), null);
      _setLoginState(AuthState.error);
      _setMessage('$e');
    }
    return false;
  }

  // O=========================================================================>
  // ? Register new user
  // <=========================================================================O

  Future<bool> register(User user) async {
    _setRegisterState(AuthState.loading);
    try {
      final repo = await authRepository.registerUser(user);
      if (repo.error == false) {
        _setRegisterState(AuthState.success);
        return true;
      } else {
        _setMessage(repo.message);
        _setRegisterState(AuthState.error);
        return false;
      }
    } catch (e) {
      _setDebugMessages('registerUser', e.toString(), null);
      _setRegisterState(AuthState.error);
      _setMessage('$e');
    }
    return false;
  }
}
