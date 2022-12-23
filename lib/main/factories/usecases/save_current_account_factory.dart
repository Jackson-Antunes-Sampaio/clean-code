
import '../../../data/usecases/save_current_account/save_current_account.dart';
import '../../../domain/usercases/save_current_account.dart';
import '../factories.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount(){


  return LocalSaveCurrentAccount(
   saveSecureCacheStorage: makeLocalStorageAdapter()
  );

}