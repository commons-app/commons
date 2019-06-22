import 'Values.dart';

class Extmetadata {
  Values dateTime;
  Values objectName;
  Values commonsMetadataExtension;
  Values categories;
  Values assessments;
  Values gPSLatitude;
  Values gPSLongitude;
  Values gPSMapDatum;
  Values imageDescription;
  Values dateTimeOriginal;
  Values credit;
  Values artist;
  Values licenseShortName;
  Values usageTerms;
  Values attributionRequired;
  Values licenseUrl;
  Values copyrighted;
  Values restrictions;
  Values license;

  Extmetadata(
      {this.dateTime, this.objectName, this.commonsMetadataExtension, this.categories, this.assessments, this.gPSLatitude, this.gPSLongitude, this.gPSMapDatum, this.imageDescription, this.dateTimeOriginal, this.credit, this.artist, this.licenseShortName, this.usageTerms, this.attributionRequired, this.licenseUrl, this.copyrighted, this.restrictions, this.license});

  Extmetadata.fromJson(Map<String, dynamic> json) {
    dateTime =
    json['DateTime'] != null ? new Values.fromJson(json['DateTime']) : null;
    objectName =
    json['ObjectName'] != null ? new Values.fromJson(json['ObjectName']) : null;
    commonsMetadataExtension =
    json['CommonsMetadataExtension'] != null ? new Values.fromJson(
        json['CommonsMetadataExtension']) : null;
    categories =
    json['Categories'] != null ? new Values.fromJson(json['Categories']) : null;
    assessments = json['Assessments'] != null
        ? new Values.fromJson(json['Assessments'])
        : null;
    gPSLatitude = json['GPSLatitude'] != null
        ? new Values.fromJson(json['GPSLatitude'])
        : null;
    gPSLongitude = json['GPSLongitude'] != null
        ? new Values.fromJson(json['GPSLongitude'])
        : null;
    gPSMapDatum = json['GPSMapDatum'] != null
        ? new Values.fromJson(json['GPSMapDatum'])
        : null;
    imageDescription = json['ImageDescription'] != null ? new Values.fromJson(
        json['ImageDescription']) : null;
    dateTimeOriginal = json['DateTimeOriginal'] != null ? new Values.fromJson(
        json['DateTimeOriginal']) : null;
    credit =
    json['Credit'] != null ? new Values.fromJson(json['Credit']) : null;
    artist =
    json['Artist'] != null ? new Values.fromJson(json['Artist']) : null;
    licenseShortName = json['LicenseShortName'] != null ? new Values.fromJson(
        json['LicenseShortName']) : null;
    usageTerms =
    json['UsageTerms'] != null ? new Values.fromJson(json['UsageTerms']) : null;
    attributionRequired =
    json['AttributionRequired'] != null ? new Values.fromJson(
        json['AttributionRequired']) : null;
    licenseUrl =
    json['LicenseUrl'] != null ? new Values.fromJson(json['LicenseUrl']) : null;
    copyrighted = json['Copyrighted'] != null
        ? new Values.fromJson(json['Copyrighted'])
        : null;
    restrictions = json['Restrictions'] != null
        ? new Values.fromJson(json['Restrictions'])
        : null;
    license =
    json['License'] != null ? new Values.fromJson(json['License']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dateTime != null) {
      data['DateTime'] = this.dateTime.toJson();
    }
    if (this.objectName != null) {
      data['ObjectName'] = this.objectName.toJson();
    }
    if (this.commonsMetadataExtension != null) {
      data['CommonsMetadataExtension'] = this.commonsMetadataExtension.toJson();
    }
    if (this.categories != null) {
      data['Categories'] = this.categories.toJson();
    }
    if (this.assessments != null) {
      data['Assessments'] = this.assessments.toJson();
    }
    if (this.gPSLatitude != null) {
      data['GPSLatitude'] = this.gPSLatitude.toJson();
    }
    if (this.gPSLongitude != null) {
      data['GPSLongitude'] = this.gPSLongitude.toJson();
    }
    if (this.gPSMapDatum != null) {
      data['GPSMapDatum'] = this.gPSMapDatum.toJson();
    }
    if (this.imageDescription != null) {
      data['ImageDescription'] = this.imageDescription.toJson();
    }
    if (this.dateTimeOriginal != null) {
      data['DateTimeOriginal'] = this.dateTimeOriginal.toJson();
    }
    if (this.credit != null) {
      data['Credit'] = this.credit.toJson();
    }
    if (this.artist != null) {
      data['Artist'] = this.artist.toJson();
    }
    if (this.licenseShortName != null) {
      data['LicenseShortName'] = this.licenseShortName.toJson();
    }
    if (this.usageTerms != null) {
      data['UsageTerms'] = this.usageTerms.toJson();
    }
    if (this.attributionRequired != null) {
      data['AttributionRequired'] = this.attributionRequired.toJson();
    }
    if (this.licenseUrl != null) {
      data['LicenseUrl'] = this.licenseUrl.toJson();
    }
    if (this.copyrighted != null) {
      data['Copyrighted'] = this.copyrighted.toJson();
    }
    if (this.restrictions != null) {
      data['Restrictions'] = this.restrictions.toJson();
    }
    if (this.license != null) {
      data['License'] = this.license.toJson();
    }
    return data;
  }
}