import 'dart:io';

import 'package:latlong/latlong.dart';

class UploadableFile {
  final File file;
  String title;
  Map<String, String> description;
  Map<String, String> caption;
  String license;
  List<String> categories;
  LatLng latLng;
  DateTime dateTime;

  UploadableFile(this.file, this.title, this.description, this.caption,
      this.license, this.categories);
}
