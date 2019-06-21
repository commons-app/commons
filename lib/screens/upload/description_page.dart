import 'package:commons/app_config.dart';
import 'package:commons/helper/upload_helper.dart';
import 'package:commons/model/UploadableFile.dart';
import 'package:commons/screens/upload/upload_category_page.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'description_presenter.dart';

class FileDescriptionPage extends StatefulWidget {
  final UploadableFile uploadableFile;

  const FileDescriptionPage({Key key, @required this.uploadableFile})
      : super(key: key);

  @override
  _FileDescriptionPageState createState() =>
      new _FileDescriptionPageState(uploadableFile);
}

class _FileDescriptionPageState extends State<FileDescriptionPage>
    implements FileDescriptionPageContract {
  BuildContext _ctx;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  UploadableFile _uploadableFile;
  ProgressDialog pr;

  FileDescriptionPagePresenter _presenter;

  var _title;
  var _caption;
  var _description;
  String _license = UploadHelper.CC_BY_3;

  _FileDescriptionPageState(uploadableFile) {
    _uploadableFile = uploadableFile;
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    if (_presenter == null) {
      var config = AppConfig.of(_ctx);
      _presenter =
      new FileDescriptionPagePresenter(config.commonsBaseUrl, this);
    }

    if (pr == null) {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
    }

    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(25.0)));

    var homeAppBar = AppBar(
      title: const Text('Upload Image'),
      actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            _submit();
          },
        ),
      ],
    );

    var uploadForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Form(
          autovalidate: true,
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(12.0),
                child: new Text(
                    "Create a unique descriptive title using plain language with spaces. Omit the file extension, if any."),
              ),
              new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new TextFormField(
                    onSaved: (val) => _title = val,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a title';
                      }
                    },
                    decoration: new InputDecoration(labelText: "Title",
                        border: outlineInputBorder),
                  )),
              new Padding(
                padding: const EdgeInsets.all(12.0),
                child: new Text(
                    "Add a one-line explanation of what this file represents, including only the most relevant information.(Optional)"),
              ),
              new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new TextFormField(
                    onSaved: (val) => _caption = val,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a caption';
                      }
                    },
                    decoration: new InputDecoration(labelText: "Caption",
                        border: outlineInputBorder),
                  )),
              new Padding(
                padding: const EdgeInsets.all(12.0),
                child: new Text(
                    "Provide all information that will help others understand what this file represents."),
              ),
              new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new TextFormField(
                    onSaved: (val) => _description = val,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a description';
                      }
                    },
                    decoration: new InputDecoration(labelText: "Description",
                        border: outlineInputBorder),
                  )),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                    "This site requires you to provide copyright information for this work, to make sure everyone can legally reuse it. I the copyright holder of this work, irrevocably grant anyone the right to use this work under the following license:"),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new DropdownButton<String>(
                  value: _license,
                  onChanged: (String newValue) {
                    setState(() {
                      _license = newValue;
                    });
                  },
                  items: <String>[
                    UploadHelper.CC0,
                    UploadHelper.CC_BY_3,
                    UploadHelper.CC_BY_4,
                    UploadHelper.CC_BY_SA_3,
                    UploadHelper.CC_BY_SA_4
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        )
      ],
    );

    return Scaffold(
      appBar: homeAppBar,
      body: new SingleChildScrollView(
          child: Stack(
              children: <Widget>[
                new Container(child: uploadForm)])),
      key: scaffoldKey,
    );
  }

  void _submit() async {
    final form = formKey.currentState;

    if (form.validate()) {
      _isLoading = true;
      form.save();


      var description = new Map<String, String>();
      description['en'] = _description.toString();
      var caption = new Map<String, String>();
      caption['en'] = _caption.toString();

      _uploadableFile.title = _title;
      _uploadableFile.description = description;
      _uploadableFile.caption = caption;
      _uploadableFile.license = _license;

      _presenter.performFileQualityChecks(_uploadableFile);
    }
  }

  Future proceedToCategorySelection() async {
    _uploadableFile = await UploadHelper().getExifFromFile(_uploadableFile);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FileCategoryPage(uploadableFile: _uploadableFile)));
  }

  @override
  void onQualityChecksFailed(List<String> errorMessages) {
    if (pr.isShowing()) {
      pr.hide();
    }
    _showSnackBar(errorMessages[0]);
  }

  @override
  void onQualityChecksPassed() async {
    if (pr.isShowing()) {
      pr.hide();
    }
    await proceedToCategorySelection();
  }
}
