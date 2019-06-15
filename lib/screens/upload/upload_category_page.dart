import 'dart:io';

import 'package:commons/app_config.dart';
import 'package:commons/helper/upload_helper.dart';
import 'package:commons/model/category.dart';
import 'package:commons/screens/upload/upload_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';

class FileCategoryPage extends StatefulWidget {
  final File file;
  final String title;
  final String caption;
  final String description;
  final String license;

  const FileCategoryPage(
      {Key key,
      @required this.file,
      @required this.title,
      @required this.caption,
      @required this.description,
      @required this.license})
      : super(key: key);

  @override
  _FileCategoryPageState createState() =>
      new _FileCategoryPageState(file, title, caption, description, license);
}

class _FileCategoryPageState extends State<FileCategoryPage>
    implements UploadPageContract {
  BuildContext _ctx;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController editingController = TextEditingController();

  bool _isLoading = false;
  File _image;
  String _license;

  var _title;
  var _caption;
  var _description;
  var _selectedCategoryItems = List<Category>();

  UploadPagePresenter _presenter;

  String dropdownValue = UploadHelper.CC_BY_3;

  _FileCategoryPageState(File file, String title, String caption,
      String description, String license) {
    _image = file;
    _title = title;
    _description = description;
    _caption = caption;
    _license = license;
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  ChipsInput chipsInput;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var config = AppConfig.of(_ctx);
    _presenter = new UploadPagePresenter(config.commonsBaseUrl, this);


    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)));

    chipsInput = new ChipsInput(
      initialValue: _selectedCategoryItems,
      decoration: InputDecoration(
          labelText: "Categories",
          border: outlineInputBorder
      ),
      maxChips: 10,
      findSuggestions: (String query) async {
        List<Category> categories = await _presenter.filterSearchResults(query);
        return categories;
      },
      onChanged: (data) {
        _selectedCategoryItems = data;
      },
      chipBuilder: (context, state, profile) {
        return InputChip(
          key: ObjectKey(profile),
          label: Text(profile.categoryName),
          avatar: CircleAvatar(
            backgroundImage: NetworkImage(profile.categoryIcon),
          ),
          onDeleted: () => state.deleteChip(profile),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      },
      suggestionBuilder: (context, state, profile) {
        return ListTile(
          key: ObjectKey(profile),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(profile.categoryIcon),
          ),
          title: Text(profile.categoryName),
          onTap: () => state.selectSuggestion(profile),
        );
      },
    );

    var homeAppBar = AppBar(
      title: new Text("Welcome to Commons!"),
    );

    var uploadBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("Upload"),
      color: Colors.green,
    );

    var uploadForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        chipsInput,
        uploadBtn
      ],
    );

    return Scaffold(
      appBar: homeAppBar,
      body: new Container(child: uploadForm),
      key: scaffoldKey,
    );
  }

  void _submit() {
    _presenter.uploadFile(_image, _title, _description, _license, _selectedCategoryItems);
  }

  @override
  void onImageUploadError(String error) {
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onImageUploadSuccess(String success) {
    _showSnackBar(success);
    setState(() {
      _isLoading = false;
    });
  }
}
