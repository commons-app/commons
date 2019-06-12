import 'dart:io';

import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/login/LoginResponse.dart';
import 'package:commons/repository/commons_api_provider.dart';

class CommonsRepository {
  CommonsApiProvider _apiProvider;

  CommonsRepository(String baseEndpoint) {
    _apiProvider = CommonsApiProvider(baseEndpoint);
  }

  Future<String> getLoginToken() {
    return _apiProvider.getLoginToken().then((MwQueryResponse value) {
      return value.getMwQueryResult().getTokens().login();
    }, onError: (e) {
      throw e;
    });
  }

  Future<LoginResponse> doLogin(String username, String password,
      String loginToken, String loginReturnUrl) {
    return _apiProvider.postLogin(
        username, password, loginToken, loginReturnUrl);
  }

  Future<String> getCsrfToken() {
    return _apiProvider.getCsrfToken().then((MwQueryResponse value) {
      return value.getMwQueryResult().getTokens().getCsrf();
    }, onError: (e) {
      throw e;
    });
  }

  Future<MwQueryResponse> uploadFile(File file, String token, String filename) {
    return _apiProvider.uploadFile(file, filename, token);
  }
}
