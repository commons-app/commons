import 'dart:io';

import 'package:commons/model/category.dart';
import 'package:commons/model/place.dart';
import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/login/LoginResponse.dart';
import 'package:commons/model/response/media/contributions.dart';
import 'package:commons/model/response/nearby/NearbyResponse.dart';
import 'package:commons/model/response/upload/UploadResult.dart';
import 'package:commons/repository/commons_api_provider.dart';
import 'package:latlong/latlong.dart';

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

  Future<UploadResult> uploadFile(File file, String token, String filename,
      String text) {
    return _apiProvider.uploadFile(file, filename, token, text);
  }

  Future<List<Place>> getNearbyPlaces(LatLng latlng) {
    return _apiProvider.getNearbyPlaces("2", latlng, "en").then((
        NearbyResponse value) {
      return value.getResults().getBindings()
          .map((val) => Place.from(val)).toList();
    }, onError: (e) {
      throw e;
    });
  }

  Future<List<Category>> searchCategories(String query) {
    return _apiProvider.searchCategories(query).then((MwQueryResponse value) {
      return value.query.search
          .map((val) => new Category(val.title.replaceAll("Category:", ""), '')).toList();
    }, onError: (e) {
      throw e;
    });
  }

  Future<List<Contribution>> fetchContributions(String userName) {
    return _apiProvider.fetchContributions(userName).then((
        ContributionsResponseDTO value) {
      return value.contributions;
    }, onError: (e) {
      throw e;
    });
  }
}
