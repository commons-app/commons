import 'dart:io';

import 'package:commons/app_config.dart';
import 'package:commons/model/UploadableFile.dart';
import 'package:commons/model/place.dart';
import 'package:commons/screens/upload/description_page.dart';
import 'package:commons/utils/distance_utils.dart';
import 'package:commons/utils/misc_util.dart';
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

  bool _isLocationUpdateSubscribed = false;
  NearbyPresenter _presenter;
  List<Marker> nearbyMarkers = List();
  List<Marker> mapMarkers = List();
  FlutterMap flutterMap;
  var controller = new MapController();

  @override
  Widget build(BuildContext context) {
    if (!_isLocationUpdateSubscribed) {
      _isLocationUpdateSubscribed = true;
      var config = AppConfig.of(this.context);
      _presenter = new NearbyPresenter(config.commonsBaseUrl, this);
      _presenter.subscribeToCurrentLocation();
    }

    flutterMap = FlutterMap(
      options: new MapOptions(
          zoom: 15.0,
          center: _currentLocation
      ),
      mapController: controller,
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
        new MarkerLayerOptions(markers: mapMarkers)
      ],
    );
    return Scaffold(body: flutterMap);
  }

  @override
  void onLocationSlightlyUpdated(LatLng latLng) {
    _currentLocation = latLng;
    var currentLocationMarker = new Marker(
      width: 25.0,
      height: 25.0,
      point: new LatLng(latLng.latitude, latLng.longitude),
      builder: (ctx) =>
      new Container(
        child: Icon(Icons.my_location),
      ),
    );

    mapMarkers.clear();
    mapMarkers.addAll(nearbyMarkers);
    mapMarkers.add(currentLocationMarker);
    setState(() {});
  }

  Future refreshNearbyPlaces(LatLng latLng) async {
    nearbyMarkers = await _presenter.getNearbyPlaces(latLng);
  }

  @override
  void onMarkerTapped(Place place) {
    _settingModalBottomSheet(context, place);
  }

  void _settingModalBottomSheet(context, Place place) {
    var distance = DistanceUtils.calculateDistance(
        _currentLocation, place.getLocation());
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(place.getName(),
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  new Text(distance.toStringAsFixed(2) + " km",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new FlatButton(onPressed: () {
                          openMaps(place.location);
                        },
                            child: new Icon(Icons.directions)),
                        new FlatButton(onPressed: () {
                          _pickImageFromCamera(place);
                        },
                            child: new Icon(Icons.camera_alt)),
                        new FlatButton(onPressed: () {
                          _pickImageFromGallery(place);
                        },
                            child: new Icon(Icons.image))
                      ],
                    ),
                  ),
                  new Text(place.getLongDescription(),
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal))
                ],
              ),
            ),
          );
        }
    );
  }

  void _showSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
    ));
  }

  @override
  void onLocationSignificantlyUpdated(LatLng latLng) async {
    controller.move(latLng, flutterMap.options.zoom);

    _currentLocation = latLng;
    var currentLocationMarker = new Marker(
      width: 25.0,
      height: 25.0,
      point: new LatLng(latLng.latitude, latLng.longitude),
      builder: (ctx) =>
      new Container(
        child: Icon(Icons.my_location),
      ),
    );

    await refreshNearbyPlaces(latLng);

    mapMarkers.clear();
    mapMarkers.addAll(nearbyMarkers);
    mapMarkers.add(currentLocationMarker);
    setState(() {});
  }

  void _pickImageFromCamera(Place place) async {
    var image = await _presenter.getImageFromCamera();
    if (image == null) {
      return;
    }
    uploadImage(image, place);
  }

  void _pickImageFromGallery(Place place) async {
    var image = await _presenter.getImageFromGallery();
    if (image == null) {
      return;
    }
    uploadImage(image, place);
  }

  void uploadImage(File image, Place place) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            UploadableFile uploadableFile = new UploadableFile(
                file: image, place: place);
            return FileDescriptionPage(uploadableFile: uploadableFile);
          },
        ));
  }
}
