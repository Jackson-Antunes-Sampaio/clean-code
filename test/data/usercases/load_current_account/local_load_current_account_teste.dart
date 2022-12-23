import 'package:curso_clean_solid/data/cache/cache.dart';
import 'package:curso_clean_solid/data/usecases/load_current_account/load_current_account.dart';
import 'package:curso_clean_solid/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:curso_clean_solid/domain/entities/entities.dart';






class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  When mockFetchSecureCall(){
    return when(fetchSecureCacheStorage.fetchSecure('any'));
  }

  void mockFetchSecure(){
    mockFetchSecureCall().thenAnswer((realInvocation) async => token);
  }
  void mockFetchSecureError(){
    mockFetchSecureCall().thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();

    mockFetchSecure();


  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('Should return an AccountEntity', () async {

    final account = await sut.load();

    expect(account, AccountEntity(token));
  });
  test('Should throw unexpectedError return an AccountEntity', () async {
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

}
