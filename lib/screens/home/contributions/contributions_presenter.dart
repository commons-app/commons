import 'package:commons/bloc/CommonsBloc.dart';
import 'package:commons/model/Media.dart';
import 'package:commons/model/response/MwQueryPage.dart';
import 'package:commons/model/response/MwQueryResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ContributionsContract {}

class ContributionsPresenter {
  ContributionsContract _view;
  CommonsBloc commonsBloc;
  Map<String, String> continuation;

  ContributionsPresenter(String baseEndpoint, this._view) {
    commonsBloc = new CommonsBloc(baseEndpoint);
  }

  Future<List<Media>> getContributions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return commonsBloc.fetchContributions(
        prefs.getString('username'), continuation).then((
        MwQueryResponse value) {
      continuation = value.continuation;
      List<Media> mediaList = new List();
      value.query.pages.forEach((MwQueryPage page) {
        mediaList.add(Media.fromPage(page));
      });
      return mediaList.reversed.toList();
    }, onError: (e) {
      throw e;
    });
  }
}
