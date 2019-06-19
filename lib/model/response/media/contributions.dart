class Contribution {
  String name;
  String timestamp;
  String url;
  String descriptionUrl;
  String descriptionShortUrl;
  String title;

  Contribution({this.name,
    this.title,
    this.timestamp,
    this.url,
    this.descriptionUrl,
    this.descriptionShortUrl});

  Contribution.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    url = json['url'];
    descriptionUrl = json['descriptionurl'];
    descriptionShortUrl = json['descriptionshorturl'];
    timestamp = json['timestamp'];
  }
}


class ContributionsResponseDTO {
  List<Contribution> contributions;

  ContributionsResponseDTO({this.contributions});

  ContributionsResponseDTO.fromJson(Map<String, dynamic> json){
    List<dynamic> allContributionsJsonList = (json['query'] as Map<
        String,
        dynamic>)['allimages'];
    contributions = [];
    for (var value in allContributionsJsonList) {
      contributions.add(Contribution.fromJson(value));
    }
  }
}

