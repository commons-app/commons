import 'dart:io';

import 'package:commons/model/place.dart';
import 'package:flutter/material.dart';
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
  Place place;

  UploadableFile(
      {@required this.file, this.title, this.description, this.caption,
        this.license, this.categories, this.place});
}
