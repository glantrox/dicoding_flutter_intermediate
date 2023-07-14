import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_intermediate/core/models/add_response.dart';
import 'package:submission_intermediate/core/models/storylist_response.dart';
import 'package:submission_intermediate/core/static/strings.dart';

import '../models/story_upload.dart';
import '../models/storydetail_response.dart';

class Repository {
  final String _baseUrl = AppString.baseUrl;

  _delay() async {
    return await Future.delayed(const Duration(milliseconds: 1500));
  }

  Future<SharedPreferences> _sharedPref() async {
    return await SharedPreferences.getInstance();
  }

  Future<String?> _savedToken() async {
    final pref = await _sharedPref();
    return pref.getString(AppString.tokenKey);
  }

  Future<AddResponse> uploadDocument(
    List<int> bytes,
    String fileName,
    String description,
    double lat,
    double lon,
  ) async {
    final token = await _savedToken();
    String url = "$_baseUrl/stories";

    final uri = Uri.parse(url);
    await _delay();
    try {
      var request = http.MultipartRequest('POST', uri);

      final multiPartFile = http.MultipartFile.fromBytes(
        "photo",
        bytes,
        filename: fileName,
      );
      final Map<String, String> fields = {
        "description": description,
        "lat": '$lat',
        "lon": '$lon',
      };
      final Map<String, String> headers = {
        "Content-type": "multipart/form-data",
        "Authorization": "Bearer $token",
      };

      request.files.add(multiPartFile);
      request.fields.addAll(fields);
      request.headers.addAll(headers);

      final http.StreamedResponse streamedResponse = await request.send();
      final int statusCode = streamedResponse.statusCode;

      final Uint8List responseList = await streamedResponse.stream.toBytes();
      final String responseData = String.fromCharCodes(responseList);

      if (statusCode == 201) {
        final AddResponse uploadResponse = AddResponse.fromJson(
          responseData,
        );
        return uploadResponse;
      } else {
        throw Exception("Upload file error");
      }
    } catch (e) {
      throw Exception('e');
    }
  }

  // O=========================================================================>
  // ? GET : Get Detail Story //
  // <=========================================================================O

  Future<StoryDetailResponse> getStoryDetail(String id) async {
    final token = await _savedToken();
    Map<String, String> header = {"Authorization": "Bearer $token"};
    try {
      await _delay();
      final response =
          await get(Uri.parse('$_baseUrl/stories/$id'), headers: header);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = StoryDetailResponse.fromJson(response.body);
        return body;
      } else {
        final error = StoryDetailResponse.fromMap(jsonDecode(response.body))
            .message
            .toString();
        throw '$error $id';
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // O=========================================================================>
  // ? POST : Add Story
  // <=========================================================================O

  Future<AddResponse> addStory(StoryUpload story) async {
    Map<String, dynamic> addBody = {
      "description": story.description,
      "photo": story.photo,
      "lat": story.lat,
      "lon": story.lon,
    };

    final token = await _savedToken();

    Map<String, String> addHeaders = {
      "Content-Type": "multipart/form-data"
          "Authorization"
          "Bearer $token"
    };

    try {
      await _delay();
      final response = await post(
        Uri.parse('$_baseUrl/stories'),
        body: addBody,
        headers: addHeaders,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = AddResponse.fromJson(response.body);

        return body;
      } else {
        final error =
            AddResponse.fromMap(jsonDecode(response.body)).error.toString();

        throw error;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // O=========================================================================>
  // ? GET : Get Stories
  // <=========================================================================O

  Future<StoryListResponse> getStories() async {
    final token = await _savedToken();
    Map<String, String> header = {"Authorization": "Bearer $token"};
    try {
      await _delay();
      final response =
          await get(Uri.parse('$_baseUrl/stories'), headers: header);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = StoryListResponse.fromJson(response.body);
        return body;
      } else {
        throw 'Terjadi Kesalahan Server';
      }
    } on StoryListResponse catch (e) {
      throw Exception('Terjadi Kesalahan Server : $e');
    }
  }
}
