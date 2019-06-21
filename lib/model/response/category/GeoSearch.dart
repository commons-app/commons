class GeoSearch {
  int pageid;
  int ns;
  String title;
  double lat;
  double lon;
  double dist;
  bool primary;

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
    lat = double.tryParse(json['lat'].toString());
    lon = double.tryParse(json['lon'].toString());
    dist = double.tryParse(json['dist'].toString());
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
