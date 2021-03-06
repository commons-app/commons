import 'dart:io';

import 'package:commons/model/GeneratorType.dart';
import 'package:commons/model/category.dart';
import 'package:commons/model/place.dart';
import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/login/LoginResponse.dart';
import 'package:commons/model/response/nearby/NearbyResponse.dart';
import 'package:commons/model/upload_interface.dart';
import 'package:commons/repository/commons_api_provider.dart';
import 'package:latlong/latlong.dart';

class CommonsRepository {
  CommonsApiProvider _apiProvider;

  CommonsRepository(String baseEndpoint) {
    _apiProvider = CommonsApiProvider(baseEndpoint);
  }

  Future<String> getLoginToken() {
    return _apiProvider.getLoginToken().then((MwQueryResponse value) {
      return value.query.getTokens().login();
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
      return value.query.getTokens().getCsrf();
    }, onError: (e) {
      throw e;
    });
  }

  void uploadFile(File file, String token, String filename,
      String text, UploadInterface uploadInterface) {
    _apiProvider.uploadFile(file, filename, token, text, uploadInterface);
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

  Future<bool> checkIfFileExists(String title) {
    return _apiProvider.checkIfFileExists(title).then((MwQueryResponse value) {
      return value.query
          .firstPage()
          .pageid != null;
    }, onError: (e) {
      throw e;
    });
  }

  Future<List<Category>> searchNearbyCategories(LatLng latLng) {
    return _apiProvider.searchNearbyCategories(latLng).then((MwQueryResponse value) {
      return value.query.geosearch
          .map((val) => new Category(val.title.replaceAll("Category:", ""), '')).toList();
    }, onError: (e) {
      throw e;
    });
  }

  Future<MwQueryResponse> fetchContributions(String userName, Map<String, String> continuation) {
    return _apiProvider.getImagesFromGenerator(
        GeneratorType.contribution, userName, continuation);
  }

  Future<MwQueryResponse> getCategoryImages(String category, Map<String, String> continuation) {
    return _apiProvider.getImagesFromGenerator(
        GeneratorType.category, category, continuation);
  }

  Future<bool> checkIfDuplicateFileExists(String sha1) {
    return _apiProvider.getImagesFromGenerator(
        GeneratorType.sha, sha1, Map()).then((
        MwQueryResponse value) {
      return value.query.pages.length > 0;
    }, onError: (e) {
      throw e;
    });
  }
}
