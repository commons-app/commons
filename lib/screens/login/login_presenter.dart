import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/response/login/LoginResponse.dart';

abstract class LoginPageContract {
  void onLoginSuccess(LoginResponse loginResponse);
  void onLoginError(String error);
}

class LoginPagePresenter {
  LoginPageContract _view;
  CommonsBloc commonsBloc;

  LoginPagePresenter(this._view, String commonsBaseUrl) {
    commonsBloc = new CommonsBloc(commonsBaseUrl);
  }

  doLogin(String username, String password) {
    commonsBloc
        .doLogin(username, password)
        .then((LoginResponse loginResponse) {
      if (loginResponse.clientlogin.status == "PASS") {
        _view.onLoginSuccess(loginResponse);
      } else {
        _view.onLoginError(loginResponse.clientlogin.message);
      }
    })
        .catchError((onError) => _view.onLoginError(onError.toString()));
  }
}