import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usercases/usercases.dart';
import '../../cache/cache.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  @override
  Future<AccountEntity> load() async {
    try{
      final token = await fetchSecureCacheStorage.fetch('token');
      return AccountEntity(token ?? '');
    }catch(e){
      throw DomainError.unexpected;
    }

  }
}