import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/response/login/LoginResponse.dart';

abstract class LoginPageContract {
  void onLoginSuccess(LoginResponse loginResponse);
  void onLoginError(String error);
}

class LoginPagePresenter {
  LoginPageContract _view;
  CommonsBloc commonsBloc = new CommonsBloc();
  LoginPagePresenter(this._view);

  doLogin(String username, String password) {
    commonsBloc
        .doLogin(username, password)
        .then((loginResponse) => _view.onLoginSuccess(loginResponse))
        .catchError((onError) => _view.onLoginError(onError.toString()));
  }
}