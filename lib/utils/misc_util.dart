import 'dart:io';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

final sourceFormat = DateFormat('yyyy-MM-dd');
final dateFormat = DateFormat.yMMMMd("en_US");

String formatDate(String date) {
  try {
    return dateFormat.format(sourceFormat.parse(date));
  } catch (Exception) {
    return "";
  }
}

String getCategoryDisplayableString(Map<String, dynamic> categoryJson) {
  var categoryString = categoryJson['value'];
  var tokenised = categoryString.toString().split("|");
  StringBuffer stringBuffer = new StringBuffer();
  for (var value in tokenised) {
    stringBuffer.write(value + " ,");
  }
  return stringBuffer
      .toString()
      .substring(0, stringBuffer.toString().length - 2);
}

void openLinkInWebBrowser(String url) async {
  launch(url);
}

void openMaps(LatLng latLng) async {
  // Android
  var url = 'geo:${latLng.latitude},${latLng.longitude}';
  if (Platform.isIOS) {
    // iOS
    url = 'http://maps.apple.com/?ll=52.32,4.917';
  }
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

DateTime getDateTimeFromString(String dateTimeString, String dateDelimiter, String timeDelimiter) {
  if(dateTimeString == null) {
    return null;
  }
  List<String> dateTimeSplit = dateTimeString.toString().split(" ");
  List<String> dateSplit = dateTimeSplit[0].split(dateDelimiter);
  List<String> timeSplit = dateTimeSplit[1].split(timeDelimiter);
  return DateTime(int.tryParse(dateSplit[0]),
      int.tryParse(dateSplit[1]),
      int.tryParse(dateSplit[2]),
      int.tryParse(timeSplit[0]),
      int.tryParse(timeSplit[1]),
      int.tryParse(timeSplit[2]));
}
