import 'package:commons/app_config.dart';
import 'package:commons/helper/upload_helper.dart';
import 'package:commons/model/UploadableFile.dart';
import 'package:commons/model/category.dart';
import 'package:commons/screens/upload/upload_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';

class FileCategoryPage extends StatefulWidget {
  final UploadableFile uploadableFile;

  const FileCategoryPage(
      {Key key,
        @required this.uploadableFile})
      : super(key: key);

  @override
  _FileCategoryPageState createState() =>
      new _FileCategoryPageState(uploadableFile);
}

class _FileCategoryPageState extends State<FileCategoryPage>
    implements UploadPageContract {
  BuildContext _ctx;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController editingController = TextEditingController();

  bool _isLoading = false;

  UploadableFile _uploadableFile;

  var _selectedCategoryItems = List<Category>();

  UploadPagePresenter _presenter;

  String dropdownValue = UploadHelper.CC_BY_3;

  _FileCategoryPageState(UploadableFile uploadableFile) {
    _uploadableFile = uploadableFile;
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
        List<Category> categories = await _presenter.filterSearchResults(_uploadableFile, query);
        return categories;
      },
      onChanged: (data) {
        _selectedCategoryItems.clear();
        for (Category category in data) {
          _selectedCategoryItems.add(category);
        }
      },
      chipBuilder: (context, state, profile) {
        return InputChip(
          key: ObjectKey(profile),
          label: Text(profile.categoryName),
          onDeleted: () => state.deleteChip(profile),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      },
      suggestionBuilder: (context, state, profile) {
        return ListTile(
          key: ObjectKey(profile),
          title: Text(profile.categoryName),
          onTap: () => state.selectSuggestion(profile),
        );
      },
    );

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

    var uploadForm = new Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          chipsInput
        ],
      ),
    );

    return Scaffold(
      appBar: homeAppBar,
      body: new Container(child: uploadForm),
      key: scaffoldKey,
    );
  }

  void _submit() {
    var categories = _selectedCategoryItems.map((val) => val.categoryName)
        .toList();
    _uploadableFile.categories = categories;
    _presenter.uploadFile(_uploadableFile);
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
    if (_uploadableFile.place != null) {
      _presenter.editWikiDataItem(_uploadableFile.title, _uploadableFile.place);
    }
    _showSnackBar(success);
    setState(() {
      _isLoading = false;
    });
  }
}
