import 'dart:io';

import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/login/LoginResponse.dart';
import 'package:dio/dio.dart';

class CommonsApiProvider {
  //String _base_endpoint =
  //  "https://commons.wikimedia.org/w/api.php?format=json&formatversion=2&errorformat=plaintext&";

  String _base_endpoint =
      "https://commons.wikimedia.beta.wmflabs.org/w/api.php?format=json&formatversion=2&errorformat=plaintext&";

  Dio _dio;

  CommonsApiProvider() {
    Options options = Options(receiveTimeout: 5000, connectTimeout: 5000);
    _dio = Dio(options);
    _setupLoggingInterceptor();
  }

  Future<MwQueryResponse> getLoginToken() async {
    try {
      var _endpoint = _base_endpoint + 'action=query&meta=tokens&type=login';
      Response response = await _dio.get(_endpoint);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw Exception(_handleError(error));
    }
  }

  Future<LoginResponse> postLogin(String username, String password,
      String loginToken, String loginReturnUrl) async {
    try {
      var _endpoint = _base_endpoint + 'action=clientlogin&rememberMe=';

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
      throw Exception(_handleError(error));
    }
  }

  Future<MwQueryResponse> getCsrfToken() async {
    try {
      var _endpoint = _base_endpoint + 'action=query&meta=tokens&type=csrf';
      Response response = await _dio.get(_endpoint);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw Exception(_handleError(error));
    }
  }

  Future<MwQueryResponse> uploadFile(File file, String filename,
      String token) async {
    try {
      var _endpoint = _base_endpoint + 'action=upload&ignorewarnings=1';

      FormData formData = new FormData.from({
        "filename": filename,
        "token": token,
        "file": new UploadFileInfo(file, filename)
      });
      Response response = await _dio.post(_endpoint, data: formData);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw Exception(_handleError(error));
    }
  }

  String _handleError(Error error) {
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          errorDescription =
              "Received invalid status code: ${error.response.statusCode}";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }

  void _setupLoggingInterceptor() {
    int maxCharactersPerLine = 200;

    _dio.interceptor.request.onSend = (Options options) {
      print("--> ${options.method} ${options.path}");
      print("Content type: ${options.contentType}");
      print("<-- END HTTP");
      return options;
    };

    _dio.interceptor.response.onSuccess = (Response response) {
      print(
          "<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
      String responseAsString = response.data.toString();
      if (responseAsString.length > maxCharactersPerLine) {
        int iterations =
            (responseAsString.length / maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          print(responseAsString.substring(
              i * maxCharactersPerLine, endingIndex));
        }
      } else {
        print(response.data);
      }
      print("<-- END HTTP");
    };
  }
}
