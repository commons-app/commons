import 'package:commons/model/UploadableFile.dart';
import 'package:exif/exif.dart';
import 'package:latlong/latlong.dart';
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
      return getPageContents(
          getDescription(uploadableFile.description),
          prefs.getString("username"),
          getTemplatedDate(uploadableFile.dateTime),
          getTemplatedCoords(uploadableFile.latLng),
          getTemplatedLicense(uploadableFile.license),
          "0.1.0",
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
        List<String> dateTimeSplit = v.toString().split(" ");
        List<String> dateSplit = dateTimeSplit[0].split(":");
        List<String> timeSplit = dateTimeSplit[1].split(":");
        dateTime = DateTime(int.tryParse(dateSplit[0]),
            int.tryParse(dateSplit[1]),
            int.tryParse(dateSplit[2]),
            int.tryParse(timeSplit[0]),
            int.tryParse(timeSplit[1]),
            int.tryParse(timeSplit[2]));
      }
    });

    uploadableFile.dateTime = dateTime;
    uploadableFile.latLng = new LatLng(lat, long);

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

  String getPageContents(String description,
      String creator,
      String templatedDate,
      String decimalCoords,
      String license,
      String version,
      String categories) {
    print(categories);
    return "== {{int:filedesc}} ==\n{{Information\n|description=$description\n|source={{own}}\n|author=[[User:$creator|$creator]]\n$templatedDate}}\n$decimalCoords\n== {{int:license-header}} ==\n$license\n\n{{Uploaded from Mobile|platform=Android|version=$version}}\n$categories";
  }

  String getDescription(Map<String, String> description) {
    return description["en"];
  }
}
