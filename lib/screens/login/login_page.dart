import 'package:commons/app_config.dart';
import 'package:commons/model/response/login/LoginResponse.dart';
import 'package:commons/utils/misc_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
      child: Text(
      'Log In',
      style: TextStyle(
          color:Colors.white, fontSize: 16.0),
    ),
      color: hexToColor("#0c609c"),
    );
    var loginForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Container(
          width : double.infinity,
          color: hexToColor("#0c609c"),
          child: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Text(
              "Log In to your account",
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        )
        ,
        new Form(
          autovalidate: false,
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
        loginBtn,
        new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new RichText(
              text: new TextSpan(
                children: [
                  new TextSpan(
                    text: "Forgot password?",
                    style: new TextStyle(color: Colors.blue, fontSize: 16),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch(
                            "https://commons.wikimedia.beta.wmflabs.org/wiki/Special:PasswordReset");
                      },
                  ),
                ],
              )),
        ),
        new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new RichText(
              text: new TextSpan(
                children: [
                  new TextSpan(
                    text: "Privacy Policy",
                    style: new TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch(
                            "https://github.com/commons-app/apps-android-commons/wiki/Privacy-policy");
                      },
                  ),
                ],
              )),
        )
      ],
    );

    return new Scaffold (
        key: scaffoldKey,
        body: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Container(height: 48),new SingleChildScrollView(
                child: new Card(
                    child: loginForm
                ))
            ]));

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
    Navigator.of(context).pushReplacementNamed("/home");
  }
}
