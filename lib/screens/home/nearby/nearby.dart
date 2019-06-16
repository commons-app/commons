import 'package:commons/app_config.dart';
import 'package:commons/model/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'nearby_presenter.dart';

class NearbyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _NearbyState();
  }
}

class _NearbyState extends State<NearbyPage> implements NearbyContract {
  LatLng _currentLocation=new LatLng(18,73);//TODO, see if we cna handle this in a better way
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  NearbyPresenter _presenter;
  List<Marker> nearbyMarkers = List();

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(this.context);
    _presenter = new NearbyPresenter(config.commonsBaseUrl, this);
    _presenter.subscribeToCurrentLocation();

    var flutterMap = new FlutterMap(
      options: new MapOptions(
        zoom: 13.0,
        center: _currentLocation
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token=pk.eyJ1IjoibWFza2FyYXZpdmVrIiwiYSI6ImNqd3RxdndwNTAyajA0MW1xeTU0djJrN2kifQ.Gbl5TlD2V2coA_5KzoS6WA",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoibWFza2FyYXZpdmVrIiwiYSI6ImNqd3RxdndwNTAyajA0MW1xeTU0djJrN2kifQ.Gbl5TlD2V2coA_5KzoS6WA',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(markers: nearbyMarkers)
      ],
    );
    return Scaffold(body: flutterMap);
  }

  @override
  void onLocationUpdated(LatLng latLng) async {
    _currentLocation = latLng;
    nearbyMarkers = await _presenter.getNearbyPlaces(latLng);
    _currentLocation=latLng;
    setState(() {});
  }

  @override
  void onMarkerTapped(Place place) {
    _showSnackBar(place.getName());
  }

  void _showSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
    ));
  }
}
