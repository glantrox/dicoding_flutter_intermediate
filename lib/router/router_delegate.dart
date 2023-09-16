import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:submission_intermediate/core/api/auth_repository.dart';
import 'package:submission_intermediate/core/api/repository.dart';
import 'package:submission_intermediate/core/static/enum.dart';
import 'package:submission_intermediate/core/static/value_keys.dart';
import 'package:submission_intermediate/interface/auth/login_screen.dart';
import 'package:submission_intermediate/interface/auth/register_screen.dart';
import 'package:submission_intermediate/interface/screens/story_add.dart';
import 'package:submission_intermediate/interface/screens/story_detail.dart';
import 'package:submission_intermediate/interface/screens/story_list.dart';
import 'package:submission_intermediate/interface/screens/story_location.dart';
import '../interface/auth/splash_screen.dart';
import '../interface/screens/story_set_location.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final AuthRepository authRepository;
  final Repository repository;
  final GlobalKey<NavigatorState> _navigatorKey;

  List<Page> _historyStack = [];
  CurrentAuth _currentAuth = CurrentAuth.auth;

  // Logged in Stack
  bool isAddStory = false;
  String? _selectedStory;
  LatLng? _selectedLocation;
  bool isSetLocation = false;

  MyRouterDelegate(this.authRepository, this.repository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    bool? authLogin = await authRepository.isLoggedIn();
    if (authLogin == true) {
      _setAuthState(CurrentAuth.success);
    } else if (authLogin == null || authLogin == false) {
      _setAuthState(CurrentAuth.login);
    }
    notifyListeners();
  }

  _authorization() async {
    if (_currentAuth == CurrentAuth.auth) {
      _setHistoryStack(_splashStack);
    } else if (_currentAuth == CurrentAuth.success) {
      _setHistoryStack(_loggedInStack);
    } else if (_currentAuth == CurrentAuth.guest) {
      _setHistoryStack(_guestStack);
    } else {
      _setHistoryStack(_loggedOutStack);
    }
  }

  @override
  Widget build(BuildContext context) {
    _authorization();
    return Navigator(
      key: _navigatorKey,
      pages: _historyStack,
      onPopPage: ((route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        _selectedStory != null ? _clearSelectedStory() : null;
        _selectedLocation != null ? _clearCurrentLocation() : null;
        isAddStory ? _setIsForm(false) : null;

        return true;
      }),
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }

  // O=========================================================================>
  // ? List Of Pages
  // <=========================================================================O

  // Stack : Splash Stack
  List<Page> get _splashStack => [const MaterialPage(child: SplashScreen())];

  // Stack : Logged Out
  List<Page> get _loggedOutStack => [
        if (_currentAuth == CurrentAuth.login)
          MaterialPage(
              key: loginScreenKey,
              child: LoginScreen(
                onGotoRegister: () => _setAuthState(CurrentAuth.register),
                onLogin: () => _setAuthState(CurrentAuth.success),
              )),
        if (_currentAuth == CurrentAuth.register)
          MaterialPage(
              key: registerScreenKey,
              child: RegisterScreen(
                  onGotoLogin: () => _setAuthState(CurrentAuth.login),
                  onRegister: () => _setAuthState(CurrentAuth.login))),
      ];
  // Stack : Logged In
  List<Page> get _loggedInStack => [
        MaterialPage(
          key: storyListScreenKey,
          child: StoryList(
            onGotoAddScreen: () => _setIsForm(true),
            onGotoDetail: (String storyId) => _setSelectedStory(storyId),
            onLogout: () => _setLogOut(),
          ),
        ),
        if (_selectedStory != null)
          MaterialPage(
            key: storyDetailScreenKey,
            child: StoryDetail(
              storyId: _selectedStory ?? "",
              onGotoLocation: (latlng) => _setCurrentLocation(latlng),
            ),
          ),
        if (_selectedLocation != null)
          MaterialPage(
              key: storyLocationScreenKey,
              child: StoryLocationScreen(
                latLng: _selectedLocation!,
                onPop: () => _clearCurrentLocation(),
              )),
        if (isAddStory)
          MaterialPage(
            key: addStoryScreenKey,
            child: AddStoryScreen(
              onGotoSetLocation: () => _setIsSetLocation(true),
              onSuccessUpload: () => _setIsForm(false),
            ),
          ),
        if (isSetLocation)
          MaterialPage(
            key: storySetLocationScreenKey,
            child: SetLocationScreen(
              onPop: () => _setIsSetLocation(false),
              onSaveLocation: () => _setIsSetLocation(false),
            ),
          )
      ];
  // Stack : Guest Stack
  List<Page> get _guestStack => [
        MaterialPage(
          key: addStoryScreenKey,
          child: AddStoryScreen(
            onGotoSetLocation: () => _setIsSetLocation(true),
            onSuccessUpload: () => _setAuthState(CurrentAuth.login),
          ),
        )
      ];

  // O=========================================================================>
  // ? Static Functions
  // <=========================================================================O

  _setAuthState(CurrentAuth state) async {
    _currentAuth = state;
    notifyListeners();
  }

  _setHistoryStack(List<Page> value) {
    _historyStack = value;
  }

  _setSelectedStory(String value) async {
    _selectedStory = value;
    notifyListeners();
  }

  _clearSelectedStory() async {
    _selectedStory = null;
    notifyListeners();
  }

  _setIsForm(bool value) async {
    isAddStory = value;
    notifyListeners();
  }

  _setCurrentLocation(LatLng value) async {
    _selectedLocation = value;
    notifyListeners();
  }

  _clearCurrentLocation() async {
    _selectedLocation = null;
    notifyListeners();
  }

  _setIsSetLocation(bool value) async {
    isSetLocation = value;
    notifyListeners();
  }

  // O=========================================================================>
  // ? Functions
  // <=========================================================================O

  _setLogOut() async {
    authRepository.setLoggedOut();
    authRepository.clearToken();
    _setAuthState(CurrentAuth.login);
    notifyListeners();
  }
}
