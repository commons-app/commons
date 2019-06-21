import 'package:commons/app_config.dart';
import 'package:commons/model/response/login/LoginResponse.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract {
  BuildContext _ctx;

  ProgressDialog pr;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _username, _password;

  LoginPagePresenter _presenter;

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      if (!pr.isShowing()) {
        pr.show();
      }
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    if (_presenter == null) {
      var config = AppConfig.of(_ctx);
      _presenter = new LoginPagePresenter(this, config.commonsBaseUrl);
    }

    if (pr == null) {
      pr = new ProgressDialog(context, ProgressDialogType.Normal);
    }

    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(25.0)));

    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("Login"),
      color: Colors.green,
    );
    var loginForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Text(
            "Log in to your account",
            textScaleFactor: 1.5,
          ),
        ),
        new Form(
          autovalidate: true,
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(20.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Username cannot be empty';
                    }
                  },
                  decoration: new InputDecoration(labelText: "Username",
                      border: outlineInputBorder),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(20.0),
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _password = val,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                  },
                  decoration: new InputDecoration(labelText: "Password",
                      border: outlineInputBorder),
                ),
              )
            ],
          ),
        ),
        loginBtn
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Commons App"),
      ),
      key: scaffoldKey,
      body: new Container(
          child: loginForm
      ));
  }

  @override
  void onLoginError(String error) {
    if (pr.isShowing()) {
      pr.hide();
    }
    _showSnackBar(error);
  }

  @override
  void onLoginSuccess(LoginResponse loginResponse) async {
    if (pr.isShowing()) {
      pr.hide();
    }

    print(loginResponse);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('username', loginResponse.clientlogin.username);
    Navigator.of(context).pushNamed("/home");
  }
}
