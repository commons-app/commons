import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:commons/model/response/media/contributions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ContributionsContract {}

class ContributionsPresenter {
  ContributionsContract _view;
  CommonsBloc commonsBloc;
  Map<String, String> continuation;

  ContributionsPresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
  }

  Future<List<AllImages>> getContributions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return commonsBloc.fetchContributions(
        prefs.getString('username'), continuation).then((
        MwQueryResponse value) {
      continuation = value.continuation;
      return value.query.allimages;
    }, onError: (e) {
      throw e;
    });
  }
}
