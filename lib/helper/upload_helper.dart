import 'package:shared_preferences/shared_preferences.dart';

class UploadHelper {
  static const String CC_BY_SA_3 = "CC BY-SA 3.0";
  static const String CC_BY_3 = "CC BY 3.0";
  static const String CC_BY_SA_4 = "CC BY-SA 4.0";
  static const String CC_BY_4 = "CC BY 4.0";
  static const String CC0 = "CC0";

  Future<String> getPageText(String description, DateTime date, double latitude,
      double longitude, String license, List<String> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("isLoggedIn")) {
      return getPageContents(
          description,
          prefs.getString("username"),
          getTemplatedDate(date),
          getTemplatedCoords(latitude, longitude),
          getTemplatedLicense(license),
          "0.1.0",
          getTemplatedCategories(categories));
    }
    return Future.error(new NullThrownError());
  }

  String getTemplatedCoords(double latitude, double longitude) {
    return "$latitude|$longitude";
  }

  String getTemplatedDate(DateTime dateTime) {
    return "{{date|" +
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
    return templatedCategory;
  }

  String getPageContents(
      String description,
      String creator,
      String templatedDate,
      String decimalCoords,
      String license,
      String version,
      String categories) {
    print(categories);
    return "== {{int:filedesc}} ==\n{{Information\n|description=$description\n|source={{own}}\n|author=[[User:$creator|$creator]]\n|date=$templatedDate}}\n{{Location|$decimalCoords}}\n== {{int:license-header}} ==\n$license\n\n{{Uploaded from Mobile|platform=Android|version=$version}}\n$categories{{subst:unc}}";
  }
}
