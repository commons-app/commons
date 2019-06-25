import 'dart:io';

import 'package:commons/model/Choice.dart';
import 'package:commons/model/UploadableFile.dart';
import 'package:commons/screens/upload/description_page.dart';
import 'package:commons/widgets/fancy_fab.dart';
import 'package:flutter/material.dart';

import 'contributions/contributions_page.dart';
import 'explore/explore_page.dart';
import 'home_presenter.dart';
import 'nearby/nearby_page.dart';

class HomePage extends StatefulWidget {
  List<String> sharedFiles;

  _HomePageState homePageState;

  HomePage({Key key})
      : super(key: key);

  @override
  _HomePageState createState() {
    homePageState=new _HomePageState();
    return homePageState;
  }


  setSharedFiled(List<String> sharedFiles){
    this.sharedFiles=sharedFiles;
    homePageState.setSharedFiles(sharedFiles);
  }
}

class _HomePageState extends State<HomePage> implements HomePageContract {
  BuildContext _ctx;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  HomePagePresenter _presenter;

  void _pickImageFromCamera() async {
    var image = await _presenter.getImageFromCamera();
    if (image == null) {
      return;
    }
    uploadImage(image);
  }

  void _pickImageFromGallery() async {
    var image = await _presenter.getImageFromGallery();
    if (image == null) {
      return;
    }
    uploadImage(image);
  }

  void uploadImage(File image) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FileDescriptionPage(
                  uploadableFile: new UploadableFile(file: image)),
        ));
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  void _selectedTab() async {
    _showSnackBar("Tab Selected");
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontWeight: FontWeight.bold);
  static var contributionsPage = new ContributionsPage();
  static var nearbyPage = new NearbyPage();
  static var explorePage = new ExplorePage();
  final widgetOptions = [
    contributionsPage,
    nearbyPage,
    explorePage,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();
    if (_presenter == null) {
      _presenter = new HomePagePresenter(this);
    }

    print("home page");
    _presenter.checkIsLogin();
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
    const Choice(title: 'Logout', icon: Icons.exit_to_app),
  ];


  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;

      switch (_selectedChoice.title) {
        case "Rate Us":
          _presenter.appReview();
          return;
        case "Send Feedback":
          _presenter.sendFeedback();
          return;
        case "Logout":
          _presenter.logout();
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

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



    return Scaffold(
      appBar: homeAppBar,
      key: scaffoldKey,
//      body: flutterMap,
      floatingActionButton: FancyFab(
        onCameraPressed: _pickImageFromCamera,
        onGalleryPressed: _pickImageFromGallery,
      ),

      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            title: Text('Contributions'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Nearby'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Explore'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void redirectUserForLogin() {
    _presenter.redirectToLogin(context);
  }

  @override
  void redirectToInitiateUpload(List<String> sharedFiles) {
    var file = File(sharedFiles[0]);
    uploadImage(file);
  }

  void setSharedFiles(List<String> sharedFiles) {
    _presenter.checkIsLogin(sharedFiles);
  }
}
