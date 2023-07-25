import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:submission_intermediate/core/api/repository.dart';
import 'package:submission_intermediate/core/models/add_response.dart';
import 'package:submission_intermediate/core/static/enum.dart';

import '../core/models/story.dart';

class StoriesProvider extends ChangeNotifier {
  AddResponse? _addResponse;
  AddResponse? get addResponse => _addResponse;

  Story? _currentStory;
  Story? get currentStory => _currentStory;

  List<Story> _listOfStories = [];
  List<Story> get listOfStories => _listOfStories;

  int? _currentPageItems = 1;
  int? get currentPageItems => _currentPageItems;

  int sizeItems = 10;

  ApiState listOfStoriesState = ApiState.init;
  ApiState detailStoryState = ApiState.init;
  ApiState uploadStoryState = ApiState.init;

  String message = "";

  // O=========================================================================>
  // ? Additional Functions
  // <=========================================================================O

  _setErrorMessage(String? value) async {
    message = value ?? "Unknown";
    notifyListeners();
  }

  _setUploadingState(ApiState value) {
    uploadStoryState = value;
    notifyListeners();
  }

  _setlistOfStoriesState(ApiState value) {
    listOfStoriesState = value;
    notifyListeners();
  }

  _setDetailStoryState(ApiState value) {
    detailStoryState = value;
    notifyListeners();
  }

  clearPages() {
    _currentPageItems = null;
    notifyListeners();
  }

  _setDebugMessages(
    String property,
    ClientException? clientException,
    String? apiException,
  ) {
    final pembatas =
        "\nO=========================================================================>\n";
    return debugPrint(pembatas +
            'Debug Exception :\n' +
            property +
            'Client Exception:\n' +
            clientException!.message ??
        "No Client Exception" + 'API Exception:\n' + apiException! ??
        "No API Exception" + pembatas);
  }

  Future<void> clearDetailStory() async {
    _currentStory = null;
    detailStoryState = ApiState.init;
    notifyListeners();
  }

  Future<void> clearListOfStories() async {
    _listOfStories = [];
    _currentPageItems = 1;
    notifyListeners();
  }

  // O=========================================================================>
  // ? Upload Story
  // <=========================================================================O

  Future<void> uploadStory(
    List<int> bytes,
    String fileName,
    String description,
    double lat,
    double lon,
  ) async {
    try {
      _setUploadingState(ApiState.loading);
      final resp = await Repository()
          .uploadDocument(bytes, fileName, description, lat, lon);
      if (resp.error == false) {
        _setlistOfStoriesState(ApiState.success);
        _setErrorMessage(resp.message ?? "Upload Success.");
        _addResponse = resp;
      } else {
        _setlistOfStoriesState(ApiState.error);
      }
      notifyListeners();
      return;
    } catch (e) {
      _setlistOfStoriesState(ApiState.error);
      _setErrorMessage(e.toString());
    }
  }

  // O=========================================================================>
  // ? Get list of Stories
  // <=========================================================================O

  Future<void> getListOfStories() async {
    try {
      if (_currentPageItems == 1) {
        _setlistOfStoriesState(ApiState.loading);
      }

      final resp = await Repository().getStories(_currentPageItems!, sizeItems);
      if (resp.error == false) {
        if (resp.listStory!.length < sizeItems) {
          _currentPageItems = null;
        } else {
          _currentPageItems = _currentPageItems! + 1;
          _listOfStories.addAll(resp.listStory ?? []);
        }

        _setlistOfStoriesState(ApiState.success);
        notifyListeners();
      } else {
        _setlistOfStoriesState(ApiState.error);
        _listOfStories = [];
      }
      notifyListeners();
      return;
    } catch (e) {
      _setlistOfStoriesState(ApiState.error);
      _setErrorMessage(e.toString());
    }
  }

  // O=========================================================================>
  // ? Get story detail
  // <=========================================================================O

  Future<void> getStoryDetail(String id) async {
    try {
      _setDetailStoryState(ApiState.loading);
      final resp = await Repository().getStoryDetail(id);
      if (resp.error == false) {
        _setDetailStoryState(ApiState.success);
        _currentStory = resp.story;
      } else {
        _setDetailStoryState(ApiState.error);
        _currentStory = null;
      }
      notifyListeners();
      return;
    } catch (e) {
      _setDetailStoryState(ApiState.error);
      _setErrorMessage(e.toString());
    }
  }
}
