import 'package:curso_clean_solid/domain/usercases/usercases.dart';
import '../../../data/usecases/usecases.dart';
import '../factories.dart';


LoadSurveys makeRemoteLoadSurveys(){
  return RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys'),
  );

}