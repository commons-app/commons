import 'dart:io';

import 'package:commons/model/category.dart';
import 'package:commons/model/place.dart';
import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/upload/UploadResult.dart';
import 'package:commons/repository/commons_repository.dart';
import 'package:latlong/latlong.dart';

class CommonsBloc {
  String baseEndpoint;
  CommonsRepository _repository;

  CommonsBloc(String baseEndpoint) {
    this.baseEndpoint = baseEndpoint;
    _repository = CommonsRepository(baseEndpoint);
  }

  doLogin(String username, String password) async {
    String loginToken = await _repository.getLoginToken();

    return _repository.doLogin(username, password, loginToken, baseEndpoint);
  }

  Future<UploadResult> uploadFile(File file, String filename,
      String text) async {
    String csrfToken = await _repository.getCsrfToken();
    return _repository.uploadFile(file, csrfToken, filename, text);
  }

  Future<List<Place>> getNearbyPlaces(LatLng latLng) async {
    return _repository.getNearbyPlaces(latLng);
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
}
