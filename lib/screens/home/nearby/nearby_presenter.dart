import 'dart:async';

import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/place.dart';
import 'package:commons/utils/distance_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

abstract class NearbyContract {
  void onLocationSlightlyUpdated(LatLng latLng);

  void onLocationSignificantlyUpdated(LatLng latLng);
  void onMarkerTapped(Place place) {}
}

class NearbyPresenter {
  LatLng _initialMapLocation;
  NearbyContract _view;
  CommonsBloc commonsBloc;

  NearbyPresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
  }

  Future<List<Marker>> getNearbyPlaces(LatLng latLng) async {
    return commonsBloc.getNearbyPlaces(latLng).then((List<Place> items) {
      return getMarkersFromPlaces(latLng, items);
    }, onError: (e) {
      throw e;
    });
  }

  void subscribeToCurrentLocation() async {
    var location = new Location();

    location.changeSettings(interval: 5000, distanceFilter: 10);
    location.onLocationChanged().listen((LocationData currentLocation) {
      var currentLatLng = new LatLng(
          currentLocation.latitude, currentLocation.longitude);
      if (DistanceUtils.calculateDistance(_initialMapLocation, currentLatLng) >
          100) {
        _initialMapLocation = currentLatLng;
        _view.onLocationSignificantlyUpdated(currentLatLng);
      } else {
        _view.onLocationSlightlyUpdated(currentLatLng);
      }
    });

    return location.getLocation().then((LocationData locationData) {
      _initialMapLocation =
      new LatLng(locationData.latitude, locationData.longitude);
      _view.onLocationSignificantlyUpdated(_initialMapLocation);
    }, onError: (e) {
      print(e);
    });
  }

  List<Marker> getMarkersFromPlaces(LatLng latLng, List<Place> items) {
    List<Marker> markers = items.map((val) {
      return new Marker(
        width: 40.0,
        height: 40.0,
        point:
        new LatLng(val
            .getLocation()
            .latitude, val
            .getLocation()
            .longitude),
        builder: (ctx) => new Container(
          child: new GestureDetector(
            child: new Transform(
              transform: new Matrix4.rotationZ(0.1),
              child: new IconButton(
                icon: Icon(Icons.location_on),
                color: Colors.deepPurple,
                tooltip: val.getName(),
                onPressed: () {
                  onMarkerPressed(val);
                },
              ),
            ),
          ),
        ),
      );
    }).toList();

    markers.add(new Marker(
      width: 25.0,
      height: 25.0,
      point: new LatLng(latLng.latitude, latLng.longitude),
      builder: (ctx) => new Container(
        child: Icon(Icons.my_location),
      ),
    ));
    return markers;
  }

  void onMarkerPressed(Place place) {
    _view.onMarkerTapped(place);
  }
}
