import 'dart:io';

import 'package:commons/model/UploadableFile.dart';
import 'package:commons/utils/misc_util.dart';
import 'package:exif/exif.dart';
import 'package:latlong/latlong.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadHelper {
  static const String CC_BY_SA_3 = "CC BY-SA 3.0";
  static const String CC_BY_3 = "CC BY 3.0";
  static const String CC_BY_SA_4 = "CC BY-SA 4.0";
  static const String CC_BY_4 = "CC BY 4.0";
  static const String CC0 = "CC0";

  Future<String> getPageText(UploadableFile uploadableFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn")) {
      String appVersion = await getAppVersion();

      return getPageContents(
          getDescription(uploadableFile.description),
          prefs.getString("username"),
          getTemplatedDate(uploadableFile.dateTime),
          getTemplatedCoords(uploadableFile.latLng),
          getTemplatedLicense(uploadableFile.license),
          appVersion,
          getTemplatedCategories(uploadableFile.categories));
    }
    return Future.error(new NullThrownError());
  }

  Future<UploadableFile> getExifFromFile(UploadableFile uploadableFile) async {
    if (uploadableFile.file == null) {
      return uploadableFile;
    }

    var bytes = await uploadableFile.file.readAsBytes();
    Map<String, IfdTag> tags = await readExifFromBytes(bytes);

    if (tags == null || tags.isEmpty) {
      return uploadableFile;
    }

    var lat, long, dateTime;
    tags.forEach((k, v) {
      print("$k: $v");
      if (k == "GPS GPSLatitude") {
        List<String> split = v.toString().replaceAll("[", "").replaceAll(
            "]", "").split(",");
        var source = split[0].trim() + "." + split[1].trim();
        lat = double.tryParse(source);
      }

      if (k == "GPS GPSLongitude") {
        List<String> split = v.toString().replaceAll("[", "").replaceAll(
            "]", "").split(",");
        var source = split[0].trim() + "." + split[1].trim();
        long = double.tryParse(source);
      }

      if (k == "Image DateTime") {
        dateTime = getDateTimeFromString(v.toString(), ":", ":");
      }
    });

    uploadableFile.dateTime = dateTime;
    if (lat != null && long != null) {
      uploadableFile.latLng = new LatLng(lat, long);
    }

    return uploadableFile;
  }

  String getTemplatedCoords(LatLng latLng) {
    if (latLng == null) {
      return "";
    }
    return "{{Location|${latLng.latitude}|${latLng.longitude}}}";
  }

  String getTemplatedDate(DateTime dateTime) {
    if (dateTime == null) {
      return "";
    }
    return "|date={{date|" +
        dateTime.year.toString() +
        "|" +
        dateTime.month.toString() +
        "|" +
        dateTime.day.toString() +
        "}}";
  }

  String licenseNameFor(String license) {
    switch (license) {
      case CC_BY_3:
        return "Attribution 3.0";
      case CC_BY_4:
        return "Attribution 4.0";
      case CC_BY_SA_3:
        return "Attribution-ShareAlike 3.0";
      case CC_BY_SA_4:
        return "Attribution-ShareAlike 4.0";
      case CC0:
        return "CC0";
    }
    return "";
  }

  String licenseUrlFor(String license) {
    switch (license) {
      case CC_BY_3:
        return "https://creativecommons.org/licenses/by/3.0/";
      case CC_BY_4:
        return "https://creativecommons.org/licenses/by/4.0/";
      case CC_BY_SA_3:
        return "https://creativecommons.org/licenses/by-sa/3.0/";
      case CC_BY_SA_4:
        return "https://creativecommons.org/licenses/by-sa/4.0/";
      case CC0:
        return "https://creativecommons.org/publicdomain/zero/1.0/";
    }
    return "";
  }

  String getTemplatedLicense(String license) {
    switch (license) {
      case CC_BY_3:
        return "{{self|cc-by-3.0}}";
      case CC_BY_4:
        return "{{self|cc-by-4.0}}";
      case CC_BY_SA_3:
        return "{{self|cc-by-sa-3.0}}";
      case CC_BY_SA_4:
        return "{{self|cc-by-sa-4.0}}";
      case CC0:
        return "{{self|cc-zero}}";
    }
    return "";
  }

  String getTemplatedCategories(List<String> categories) {
    String templatedCategory = "";
    for (String category in categories) {
      print(category);
      templatedCategory = templatedCategory + "\n[[Category:$category]]";
    }

    if (templatedCategory == "") {
      return "{{subst:unc}}";
    } else {
      return templatedCategory;
    }
  }

  String getPlatform() {
    if (Platform.isIOS) {
      return "IOS";
    } else {
      return "Android";
    }
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  String getPageContents(String description,
      String creator,
      String templatedDate,
      String decimalCoords,
      String license,
      String version,
      String categories) {
    return "== {{int:filedesc}} ==\n{{Information\n|description=$description\n|source={{own}}\n|author=[[User:$creator|$creator]]\n$templatedDate}}\n$decimalCoords\n== {{int:license-header}} ==\n$license\n\n{{Uploaded from Mobile|platform=${getPlatform()}|version=$version}}\n$categories";
  }

  String getDescription(Map<String, String> description) {
    return description["en"];
  }
}
