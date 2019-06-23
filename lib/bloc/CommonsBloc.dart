import 'dart:io';

import 'package:commons/model/category.dart';
import 'package:commons/model/place.dart';
import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/login/LoginResponse.dart';
import 'package:commons/model/upload_interface.dart';
import 'package:commons/repository/commons_repository.dart';
import 'package:latlong/latlong.dart';

class CommonsBloc {
  String baseEndpoint;
  CommonsRepository _repository;

  CommonsBloc(String baseEndpoint) {
    this.baseEndpoint = baseEndpoint;
    _repository = CommonsRepository(baseEndpoint);
  }

  Future<LoginResponse> doLogin(String username, String password) async {
    String loginToken = await _repository.getLoginToken();

    return _repository.doLogin(username, password, loginToken, baseEndpoint);
  }

  void uploadFile(File file, String filename,
      String text, UploadInterface uploadInterface) async {
    String csrfToken = await _repository.getCsrfToken();
    return _repository.uploadFile(file, csrfToken, filename, text, uploadInterface);
  }

  Future<List<Place>> getNearbyPlaces(LatLng latLng) async {
    return _repository.getNearbyPlaces(latLng);
  }

  Future<bool> checkIfPageExists(String title) async {
    return _repository.checkIfFileExists(title);
  }

  Future<List<Category>> getCategories(String query) async {
    return _repository.searchCategories(query);
  }

  Future<List<Category>> getNearbyCategories(LatLng latLng) async {
    return _repository.searchNearbyCategories(latLng);
  }

  Future<MwQueryResponse> fetchContributions(String userName,
      Map<String, String> continuation) async {
    return _repository.fetchContributions(userName, continuation);
  }

  Future<MwQueryResponse> getFeaturedImages(
      String category, Map<String, String> continuation) async {
    return _repository.getCategoryImages(category, continuation);
  }

  Future<bool> checkIfDuplicateFileExists(String sha1) {
    return _repository.checkIfDuplicateFileExists(sha1);
  }
}
