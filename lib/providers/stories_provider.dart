import 'package:flutter/foundation.dart';
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

  ApiState listOfStoriesState = ApiState.init;
  ApiState detailStoryState = ApiState.init;
  ApiState uploadStoryState = ApiState.init;

  String message = "";

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

  Future<void> clearDetailStory() async {
    _currentStory = null;
    detailStoryState = ApiState.init;
    notifyListeners();
  }

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

  Future<void> getListOfStories() async {
    try {
      _setlistOfStoriesState(ApiState.loading);
      final resp = await Repository().getStories();
      if (resp.error == false) {
        _setlistOfStoriesState(ApiState.success);
        _listOfStories = resp.listStory ?? [];
        debugPrint('Provider Success');
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
