import 'package:commons/model/response/nearby/NearbyResultItem.dart';
import 'package:latlong/latlong.dart';

import 'site_links.dart';

class Place {
  final String name;
  final String label;
  final String longDescription;
  final LatLng location;
  final String category;
  String distance;
  final Sitelinks siteLinks;

  Place(this.name, this.label, this.longDescription, this.location,
      this.category, this.siteLinks);

  static Place from(NearbyResultItem item) {
    String itemClass = item.getClassName().getValue();
    //print(itemClass);
    String classEntityId = "";
    if (itemClass != "") {
      classEntityId =
          itemClass.replaceAll("http://www.wikidata.org/entity/", "");
    }

    //print(classEntityId);

    Sitelinks sitelinks = new Sitelinks(item.getWikipediaArticle().getValue(),
        item.getCommonsArticle().getValue(), item.getItem().getValue());

//    print(sitelinks);
//
//    print(item.getLabel().getValue());
//
//    print(item.getClassLabel().getValue());
//
//    print(latLngFromPointString(item.getLocation().getValue()));
//
//    print(item.getCommonsCategory().getValue());
//
//    print(sitelinks);

    return new Place(
        item.getLabel().getValue(),
        classEntityId,
        item.getClassLabel().getValue(),
        latLngFromPointString(item.getLocation().getValue()),
        item.getCommonsCategory().getValue(),
        sitelinks);
  }

  static LatLng latLngFromPointString(String pointString) {
    var location = pointString.replaceAll("Point(", "").replaceAll(")", "");
    List<String> matcher = location.split(" ");
    return new LatLng(
        double.tryParse(matcher[1]) ?? 0.0, double.tryParse(matcher[0]) ?? 0.0);
  }

  String getName() {
    return name;
  }

  String getLabel() {
    return label;
  }

  LatLng getLocation() {
    return location;
  }

  String getLongDescription() {
    return longDescription;
  }

  String getCategory() {
    return category;
  }

  void setDistance(String distance) {
    this.distance = distance;
  }

  String getWikiDataEntityId() {
    if (!hasWikidataLink()) {
      return null;
    }
    String wikiDataLink = siteLinks.getWikidataLink().toString();
    return wikiDataLink.replaceAll("http://www.wikidata.org/entity/", "");
  }

  bool hasWikipediaLink() {
    return !((siteLinks == null) ||
        ("" == siteLinks.getWikipediaLink().toString()));
  }

  bool hasWikidataLink() {
    return !((siteLinks == null) ||
        ("" == siteLinks.getWikidataLink().toString()));
  }

  bool hasCommonsLink() {
    return !((siteLinks == null) ||
        ("" == siteLinks.getCommonsLink().toString()));
  }
}
