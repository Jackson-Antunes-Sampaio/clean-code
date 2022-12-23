import 'package:curso_clean_solid/main/decorators/decorators.dart';
import 'package:curso_clean_solid/main/factories/factories.dart';

import '../../../data/http/http.dart';

class Test implements DeleteSecureCacheStorage{
  @override
  Future<void> delete(String key)async {

  }
}

HttpClient makeAuthorizeHttpClientDecorator(){
  Test test = Test();
  return AuthorizeHttpClientDecorator(
    decoratee: makeHttpAdapter(),
    fetchSecureCacheStorage: makeLocalStorageAdapter(),
    deleteSecureCacheStorage: test
  );

}