import 'dart:convert';
import 'dart:io';

import 'package:commons/model/GeneratorType.dart';
import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/login/LoginResponse.dart';
import 'package:commons/model/response/nearby/NearbyResponse.dart';
import 'package:commons/model/response/upload/UploadResult.dart';
import 'package:commons/model/upload_interface.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:latlong/latlong.dart';
import 'package:path_provider/path_provider.dart';


class CommonsApiProvider {
  final String THUMB_SIZE = "640";
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

  void uploadFile(File file, String filename,
      String token, String text, UploadInterface uploadInterface) async {
    try {
      var _endpoint = _url_prefix + 'action=upload&ignorewarnings=1';

      FormData formData = new FormData.from({
        "filename": filename,
        "token": token,
        "file": new UploadFileInfo(file, filename),
        "text": text
      });
      Response response = await _dio.post(
          _endpoint, data: formData, onSendProgress: (int sent, int total) {
        print("$sent $total");
        uploadInterface.onUploadProgessChanged(sent, total);
      });
      UploadResult uploadResult = UploadResult.fromJson(response.data);
      uploadInterface.onUploadSuccessful(uploadResult);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      uploadInterface.onUploadFailure(error);
    }
  }


  Future<MwQueryResponse> searchCategories(String query) async {
    try {
      var _endpoint = _url_prefix +
          'action=query&list=search&srwhat=text&srnamespace=14&srlimit=10&srsearch=$query';

      Response response = await _dio.get(_endpoint);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw error;
    }
  }

  Future<MwQueryResponse> checkIfFileExists(String title) async {
    try {
      var _endpoint = _url_prefix +
          'action=query&format=json&formatversion=2&titles=$title';

      Response response = await _dio.get(_endpoint);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw error;
    }
  }

  Future<MwQueryResponse> searchNearbyCategories(LatLng latLng) async {
    try {
      var _endpoint = _url_prefix +
          'action=query&list=geosearch&gsprimary=all&gsnamespace=14&gsradius=10000&gscoord=${latLng
              .latitude}|${latLng.longitude}';

      Response response = await _dio.get(_endpoint);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw error;
    }
  }

  Future<NearbyResponse> getNearbyPlaces(String radius,
      LatLng latLng,
      String language) async {
    String query = getNearbyQuery(
        radius, latLng.latitude, latLng.longitude, language);
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
       bd:serviceParam wikibase:center 'Point($longitude $latitude)'^^geo:wktLiteral.
       bd:serviceParam wikibase:radius '$radius' .
     }

     MINUS {?item wdt:P18 []}

     OPTIONAL {?item rdfs:label ?itemLabelPreferredLanguage. FILTER (lang(?itemLabelPreferredLanguage) = '$language')}
     OPTIONAL {?item rdfs:label ?itemLabelAnyLanguage}

     OPTIONAL { ?item wdt:P373 ?commonsCategory. }

     OPTIONAL {
       ?item p:P31/ps:P31 ?classId.
       OPTIONAL {?classId rdfs:label ?classLabelPreferredLanguage. FILTER (lang(?classLabelPreferredLanguage) = '$language')}
       OPTIONAL {?classId rdfs:label ?classLabelAnyLanguage}

       OPTIONAL {
           ?wikipediaArticle   schema:about ?item ;
                               schema:isPartOf <https://$language.wikipedia.org/> .
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

  Future<MwQueryResponse> getImagesFromGenerator(GeneratorType type,
      String filter,
      Map<String, String> continuation) async {
    try {
      var _endpoint = _url_prefix +
          'action=query&${getGeneratorParams(type, filter)}'
              '&prop=imageinfo&iiprop=url|extmetadata&iiurlwidth=$THUMB_SIZE&'
              'iiextmetadatafilter=DateTime|Categories|GPSLatitude|GPSLongitude|ImageDescription|DateTimeOriginal|Artist|LicenseShortName|LicenseUrl';

      if (continuation != null) {
        for (String key in continuation.keys) {
          _endpoint = _endpoint + "&$key=${continuation[key]}";
        }
      }

      Response response = await _dio.get(_endpoint);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw error;
    }
  }

  String getGeneratorParams(GeneratorType type, String filter) {
    switch (type) {
      case GeneratorType.category:
        return "generator=categorymembers&gcmtype=file&gcmtitle=Category:$filter&gcmlimit=10";
        break;
      case GeneratorType.contribution:
        return "generator=allimages&gaiuser=$filter&gailimit=10&gaisort=timestamp&gaidir=descending";
        break;
      case GeneratorType.sha:
        return "generator=allimages&aisha1=$filter&gailimit=10";
        break;
    }
    return "";
  }

  Future<MwQueryResponse> checkIfDuplicateFileExists(String sha1) async {
    try {
      var _endpoint = _url_prefix +
          'action=query&format=json&formatversion=2&list=allimages&aisha1=$sha1';
      Response response = await _dio.get(_endpoint);
      return MwQueryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      throw error;
    }
  }
}
