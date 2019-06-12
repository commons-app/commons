import 'dart:io';

import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/login/LoginResponse.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class CommonsApiProvider {
  String _base_endpoint;
  String _url_prefix;

  Dio _dio;

  CommonsApiProvider(String baseEndpoint) {
    _base_endpoint = baseEndpoint;
    _url_prefix =
        _base_endpoint + "?format=json&formatversion=2&errorformat=plaintext&";
    BaseOptions options = BaseOptions(
        receiveTimeout: 5000, connectTimeout: 5000);
    _dio = Dio(options);
    _dio.interceptors.add(LogInterceptor(responseBody: true));

    addCookieJar();

  }

  Future addCookieJar() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar persistedCookieJar = new PersistCookieJar(dir: tempPath);
    _dio.interceptors.add(CookieManager(persistedCookieJar));
  }

  Future<MwQueryResponse> getLoginToken() async {
    try {
      var _endpoint = _url_prefix + 'action=query&meta=tokens&type=login';
      Response response = await _dio.get(_endpoint);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw error;
    }
  }

  Future<LoginResponse> postLogin(String username, String password,
      String loginToken, String loginReturnUrl) async {
    try {
      var _endpoint = _url_prefix + 'action=clientlogin&rememberMe=';

      print(loginToken);
      Response response = await _dio.post(_endpoint, data: {
        "username": username,
        "password": password,
        "logintoken": loginToken,
        "loginreturnurl": loginReturnUrl
      }, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded")));
      return LoginResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw error;
    }
  }

  Future<MwQueryResponse> getCsrfToken() async {
    try {
      var _endpoint = _url_prefix + 'action=query&meta=tokens&type=csrf';
      Response response = await _dio.get(_endpoint);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw error;
    }
  }

  Future<MwQueryResponse> uploadFile(File file, String filename,
      String token, String text) async {
    try {
      var _endpoint = _url_prefix + 'action=upload&ignorewarnings=1';

      FormData formData = new FormData.from({
        "filename": filename,
        "token": token,
        "file": new UploadFileInfo(file, filename),
        "text": text
      });
      Response response = await _dio.post(_endpoint, data: formData);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw error;
    }
  }
}
