import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usercases/usercases.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity accountEntity) async {
    try{
      await saveSecureCacheStorage.save(
          key: 'token', value: accountEntity.token);
    }catch(e){
      throw DomainError.unexpected;
    }

  }
}