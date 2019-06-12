import 'dart:io';

import 'package:commons/model/Place.dart';
import 'package:commons/repository/commons_repository.dart';

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

  uploadFile(File file, String filename, String text) async {
    String csrfToken = await _repository.getCsrfToken();
    return _repository.uploadFile(file, csrfToken, filename, text);
  }

  Future<List<Place>> getNearbyPlaces() async {
    return _repository.getNearbyPlaces();
  }
}
