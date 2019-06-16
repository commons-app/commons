import 'dart:io';

import 'package:commons/app_config.dart';
import 'package:commons/model/Choice.dart';
import 'package:commons/model/place.dart';
import 'package:commons/screens/login/login_page.dart';
import 'package:commons/screens/upload/description_page.dart';
import 'package:commons/widgets/fancy_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_presenter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomePageContract {
  BuildContext _ctx;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  File _image;
  LatLng _currentLocation = new LatLng(12.95, 77.64);
  HomePagePresenter _presenter;

  void _pickImageFromCamera() async {
    var image = await _presenter.getImageFromCamera();

    uploadImage(image);

    setState(() {
      _image = image;
    });
  }

  void _pickImageFromGallery() async {
    var image = await _presenter.getImageFromGallery();

    uploadImage(image);

    setState(() {
      _image = image;
    });
  }

  void uploadImage(File image) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FileDescriptionPage(file: image),
        ));
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  void initState() {
    super.initState();
    checkIsLogin();
  }

  List<Marker> nearbyMarkers = List();

  Future<Null> checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoggedIn = prefs.getBool("isLoggedIn");
    if (isLoggedIn == null || !isLoggedIn) {
      print("User is not logged in");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => new LoginPage()),
      );
    } else {
      _presenter.subscribeToCurrentLocation();
    }
  }

  Widget gallery() {
    return Container(
      child: FloatingActionButton(
        onPressed: _pickImageFromGallery,
        tooltip: 'Gallery',
        child: Icon(Icons.image),
      ),
    );
  }

  Widget camera() {
    return Container(
      child: FloatingActionButton(
        onPressed: _pickImageFromCamera,
        tooltip: 'Camera',
        child: Icon(Icons.photo_camera),
      ),
    );
  }

  bool popupShown = false;

  Choice _selectedChoice = choices[0]; // The app's "state".

  static const List<Choice> choices = const <Choice>[
    const Choice(title: 'Rate Us', icon: Icons.star),
    const Choice(title: 'Send Feedback', icon: Icons.feedback),
  ];


  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var config = AppConfig.of(_ctx);
    _presenter = new HomePagePresenter(config.commonsBaseUrl, this);

    var homeAppBar = AppBar(
      title: const Text('Home'),
      actions: <Widget>[
        // action button
        // overflow menu
        PopupMenuButton<Choice>(
          onSelected: _select,
          itemBuilder: (BuildContext context) {
            return choices.map((Choice choice) {
              return PopupMenuItem<Choice>(
                value: choice,
                child: Text(choice.title),
              );
            }).toList();
          },
        ),
      ],
    );

    var flutterMap = new FlutterMap(
      options: new MapOptions(
        center: _currentLocation,
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token=pk.eyJ1IjoibWFza2FyYXZpdmVrIiwiYSI6ImNqd3RxdndwNTAyajA0MW1xeTU0djJrN2kifQ.Gbl5TlD2V2coA_5KzoS6WA",
          additionalOptions: {
            'accessToken': 'pk.eyJ1IjoibWFza2FyYXZpdmVrIiwiYSI6ImNqd3RxdndwNTAyajA0MW1xeTU0djJrN2kifQ.Gbl5TlD2V2coA_5KzoS6WA',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(markers: nearbyMarkers)
      ],
    );

    return Scaffold(
      appBar: homeAppBar,
      key: scaffoldKey,
      body: flutterMap,
      floatingActionButton: FancyFab(
        onCameraPressed: _pickImageFromCamera,
        onGalleryPressed: _pickImageFromGallery,
      ),
    );
  }

  @override
  void onMarkerTapped(Place place) {
    _showSnackBar(place.getName());
  }

  @override
  void onLocationUpdated(LatLng latLng) async {
    _currentLocation = latLng;
    nearbyMarkers = await _presenter.getNearbyPlaces(latLng);
    setState(() {});
  }
}
