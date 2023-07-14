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

  Future<SharedPreferences> _sharedPref() async {
    return await SharedPreferences.getInstance();
  }

  _setErrorMessage(String? value) async {
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

  _setLogoutState(AuthState value) async {
    logoutState = value;
    notifyListeners();
  }

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
        _setLoginState(AuthState.error);
        return false;
      }
      isLoggedIn = await authRepository.isLoggedIn();
      _setLoginState(AuthState.init);
      return isLoggedIn;
    } catch (e) {
      _setLoginState(AuthState.error);
      _setErrorMessage(e.toString());
    }
    return false;
  }

  Future<bool> register(User user) async {
    _setRegisterState(AuthState.loading);
    try {
      final repo = await authRepository.registerUser(user);
      if (repo.error == false) {
        _setRegisterState(AuthState.success);
        return true;
      } else {
        _setRegisterState(AuthState.error);
        return false;
      }
    } catch (e) {
      _setRegisterState(AuthState.error);
      _setErrorMessage(e.toString());
      debugPrint('REPOSITORY ERROR ( Register User )\n$e');
    }
    return false;
  }
}
