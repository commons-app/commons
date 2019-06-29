import 'package:commons/model/category.dart';
import 'package:commons/model/response/MwQueryPage.dart';
import 'package:commons/model/response/media/ImageInfo.dart';
import 'package:commons/utils/misc_util.dart';
import 'package:latlong/latlong.dart';

class Media {
  final String name;
  final String thumbUrl;
  final String url;
  final String licenseName;
  final String licenseUrl;
  final LatLng latLng;
  final DateTime uploadDateTime;
  final String description;
  final List<Category> categories;

  Media({this.name,
    this.thumbUrl,
    this.url,
    this.licenseName,
    this.licenseUrl,
    this.latLng,
    this.uploadDateTime,
    this.description,
    this.categories});

  String prettyName() {
    String prettyName = name.substring(0, name.lastIndexOf("."));
    return prettyName.replaceAll("_", " ").replaceAll("File:", "");
  }

  static Media fromPage(MwQueryPage page) {
    ImageInfo imageInfo = page.imageinfo[0];
    var extmetadata = imageInfo.extmetadata;

    List<Category> categoryList = List();
    extmetadata.categories.value.split("|").forEach((String category) {
      categoryList.add(Category(category.trim(), ""));
    });

    var mediaLatLng;
    if(extmetadata.gPSLatitude!=null && extmetadata.gPSLongitude!=null) {
      var _latitude = double.parse(extmetadata.gPSLatitude?.value);
      var _longitude = double.parse(extmetadata.gPSLongitude?.value);
      mediaLatLng = new LatLng(_latitude, _longitude);
    }

    var dateTimeFromString = getDateTimeFromString(extmetadata?.dateTime?.value, "-", ":");

    return Media(
        name: page.title,
        thumbUrl: imageInfo.url,
        url: imageInfo.url,
        description: extmetadata.imageDescription?.value,
        licenseName: extmetadata.licenseShortName?.value,
        licenseUrl: extmetadata.licenseUrl?.value,
        latLng: mediaLatLng == null? new LatLng(0, 0): mediaLatLng,
        uploadDateTime: dateTimeFromString,
        categories: categoryList);
  }
}
