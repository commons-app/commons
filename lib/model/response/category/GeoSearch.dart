class GeoSearch {
  int pageid;
  int ns;
  String title;
  double lat;
  double lon;
  double dist;
  String primary;

  GeoSearch(
      {this.pageid,
      this.ns,
      this.title,
      this.lat,
      this.lon,
      this.dist,
      this.primary});

  GeoSearch.fromJson(Map<String, dynamic> json) {
    pageid = json['pageid'];
    ns = json['ns'];
    title = json['title'];
    lat = json['lat'];
    lon = json['lon'];
    dist = json['dist'];
    primary = json['primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageid'] = this.pageid;
    data['ns'] = this.ns;
    data['title'] = this.title;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['dist'] = this.dist;
    data['primary'] = this.primary;
    return data;
  }
}
