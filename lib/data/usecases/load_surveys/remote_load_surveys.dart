import 'package:curso_clean_solid/domain/usercases/usercases.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveys implements LoadSurveys{
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({required this.url, required this.httpClient});

  @override
  Future<List<SurveyEntity>> load() async {
    try{
      final httResponse =  await httpClient.request(url: url, method: 'get');
      return (httResponse as List).map((e) {
        return RemoteSurveyModel.fromJson(e).toEntity();
      }).toList();
    }on HttpError catch(e){
      throw e == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }

  }
}
