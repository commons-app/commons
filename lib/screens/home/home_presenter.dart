import 'dart:async';
import 'dart:io';

import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/helper/upload_helper.dart';
import 'package:commons/model/Place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';

abstract class HomePageContract {
  void onMarkerTapped(Place place);
}

class HomePagePresenter {
  HomePageContract _view;
  CommonsBloc commonsBloc;
  UploadHelper _uploadHelper;


  HomePagePresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
    _uploadHelper = new UploadHelper();
  }

  Future<File> getImageFromCamera() async {
    return ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future<File> getImageFromGallery() async {
    return ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<List<Marker>> getNearbyPlaces() async {
    return commonsBloc.getNearbyPlaces()
        .then((List<Place> items) {
      return items.map((val) {
        return new Marker(
          width: 25.0,
          height: 25.0,
          point: new LatLng(val
              .getLocation()
              .latitude, val
              .getLocation()
              .longitude),
          builder: (ctx) =>
          new Container(
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
      })
          .toList();
    }, onError: (e) {
      throw e;
    });;
  }

  void onMarkerPressed(Place place) {
    _view.onMarkerTapped(place);
  }
}
