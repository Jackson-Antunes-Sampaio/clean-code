import 'package:curso_clean_solid/domain/usercases/usercases.dart';
import '../../../data/usecases/usecases.dart';
import '../factories.dart';


AddAccount makeRemoteAddAccount(){
  return RemoteAddAccount(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('signup'),
  );

}