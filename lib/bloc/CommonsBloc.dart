import 'dart:io';

import 'package:commons/repository/commons_repository.dart';

class CommonsBloc {
  String COMMONS_URL = "https://commons.wikimedia.org/";

  final CommonsRepository _repository = CommonsRepository();

  doLogin(String username, String password) async {
    String loginToken = await _repository.getLoginToken();

    return _repository.doLogin(username, password, loginToken, COMMONS_URL);
  }

  uploadFile(File file, String filename) async {
    String csrfToken = await _repository.getCsrfToken();
    return _repository.uploadFile(file, csrfToken, filename);
  }
}

final bloc = CommonsBloc();
