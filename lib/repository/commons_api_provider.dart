import 'dart:convert';
import 'dart:io';

import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/login/LoginResponse.dart';
import 'package:commons/model/response/nearby/NearbyResponse.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class CommonsApiProvider {
  String _base_endpoint;
  String _url_prefix;
  String _sparql_query_endpoint = "https://query.wikidata.org/sparql";

  Dio _dio;

  CommonsApiProvider(String baseEndpoint) {
    _base_endpoint = baseEndpoint;
    _url_prefix =
        _base_endpoint + "?format=json&formatversion=2&errorformat=plaintext&";
    BaseOptions options = BaseOptions(
        receiveTimeout: 60000, connectTimeout: 60000);
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

  Future<NearbyResponse> getNearbyPlaces(String radius,
      double latitude,
      double longitude,
      String language) async {
    String query = getNearbyQuery(radius, latitude, longitude, language);
    try {
      var _endpoint = _sparql_query_endpoint + '?format=json&query=' + query;

      Response<String> response = await _dio.get(
          _endpoint, options: new Options(
          responseType: ResponseType.plain
      ));
      return NearbyResponse.fromJson(jsonDecode(response.data));
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw error;
    }
  }

//  Future<NearbyResponse> getNearbyPlaces() async {
//    String json = await _loadNearbyAsset();
//    //print(json);
//    NearbyResponse response = NearbyResponse.fromJson(jsonDecode(json));
//    var bindings = response.getResults().getBindings();
//    return NearbyResponse.fromJson(jsonDecode(json));
//  }

  String getNearbyQuery(String radius,
      double latitude,
      double longitude,
      String language) {
    return """SELECT
     (SAMPLE(?location) as ?location)
     ?item
     (SAMPLE(COALESCE(?itemLabelPreferredLanguage, ?itemLabelAnyLanguage)) as ?label)
     (SAMPLE(?classId) as ?class)
     (SAMPLE(COALESCE(?classLabelPreferredLanguage, ?classLabelAnyLanguage, '?')) as ?classLabel)
     (SAMPLE(COALESCE(?icon0, ?icon1)) as ?icon)
     ?wikipediaArticle
     ?commonsArticle
     (SAMPLE(?commonsCategory) as ?commonsCategory)
   WHERE {
     SERVICE wikibase:around {
       ?item wdt:P625 ?location.
       bd:serviceParam wikibase:center 'Point(77.64 12.95)'^^geo:wktLiteral.
       bd:serviceParam wikibase:radius '1' .
     }

     MINUS {?item wdt:P18 []}

     OPTIONAL {?item rdfs:label ?itemLabelPreferredLanguage. FILTER (lang(?itemLabelPreferredLanguage) = 'en')}
     OPTIONAL {?item rdfs:label ?itemLabelAnyLanguage}

     OPTIONAL { ?item wdt:P373 ?commonsCategory. }

     OPTIONAL {
       ?item p:P31/ps:P31 ?classId.
       OPTIONAL {?classId rdfs:label ?classLabelPreferredLanguage. FILTER (lang(?classLabelPreferredLanguage) = 'en')}
       OPTIONAL {?classId rdfs:label ?classLabelAnyLanguage}

       OPTIONAL {
           ?wikipediaArticle   schema:about ?item ;
                               schema:isPartOf <https://\$language.wikipedia.org/> .
         }
       OPTIONAL {
           ?wikipediaArticle   schema:about ?item ;
                               schema:isPartOf <https://en.wikipedia.org/> .
           SERVICE wikibase:label { bd:serviceParam wikibase:language 'en' }
         }

         OPTIONAL {
           ?commonsArticle   schema:about ?item ;
                               schema:isPartOf <https://commons.wikimedia.org/> .
           SERVICE wikibase:label { bd:serviceParam wikibase:language 'en' }
         }
     }
   }
   GROUP BY ?item ?wikipediaArticle ?commonsArticle""";
  }

  Future<String> _loadNearbyAsset() async {
    return await rootBundle.loadString('assets/nearby.json');
  }
}
