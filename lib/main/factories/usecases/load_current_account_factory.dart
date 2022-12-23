import '../../../data/usecases/usecases.dart';
import '../../../domain/usercases/usercases.dart';
import '../factories.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount(){
  return LocalLoadCurrentAccount(
   fetchSecureCacheStorage: makeLocalStorageAdapter()
  );
}