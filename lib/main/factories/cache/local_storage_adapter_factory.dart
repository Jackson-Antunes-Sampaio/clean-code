import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../infra/http/cache/cache.dart';




LocalStorageAdapter makeLocalStorageAdapter(){

  const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  return LocalStorageAdapter(secureStorage: secureStorage);

}