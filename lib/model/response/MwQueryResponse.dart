import 'MwQueryResult.dart';
import 'MwResponse.dart';
import 'MwServiceError.dart';

class MwQueryResponse extends MwResponse {
  bool batchcomplete;
  Map<String, String> continuation;
  MwQueryResult query;

  MwQueryResponse(
      {errors, servedBy, this.batchcomplete, this.continuation, this.query})
      : super(errors: errors, servedBy: servedBy);

  MwQueryResponse.fromJson(Map<String, dynamic> json) {
    errors = (json['errors'] as List)
        ?.map((e) => e == null
            ? null
            : MwServiceError.fromJson(e as Map<String, dynamic>))
        ?.toList();
    servedBy = json['servedBy'] as String;
    batchcomplete = json['batchcomplete'];
    continuation = (json['continue'] as Map<String, dynamic>)?.map(
      (k, e) {
        if (e is String) {
          return MapEntry(k, e);
        } else {
          return MapEntry(k, e.toString());
        }
      },
    );
    query = json['query'] != null
        ? new MwQueryResult.fromJson(json['query'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batchcomplete'] = this.batchcomplete;
    if (this.continuation != null) {
      data['continue'] = this.continuation;
    }
    if (this.query != null) {
      data['query'] = this.query.toJson();
    }
    return data;
  }
}
