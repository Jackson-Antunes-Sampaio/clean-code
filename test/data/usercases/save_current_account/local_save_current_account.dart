import 'package:curso_clean_solid/data/cache/cache.dart';
import 'package:curso_clean_solid/data/usecases/save_current_account/save_current_account.dart';
import 'package:curso_clean_solid/domain/entities/entities.dart';
import 'package:curso_clean_solid/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';





class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  late LocalSaveCurrentAccount sut;
  late SaveSecureCacheStorageSpy secureCacheStorage;
  late AccountEntity account;

  mockError(){
    when(secureCacheStorage.saveSecure(key: 'key', value: 'value'))
        .thenThrow(Exception());

  }

  setUp((){
    secureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
    LocalSaveCurrentAccount(saveSecureCacheStorage: secureCacheStorage);
    account = AccountEntity(faker.guid.guid());

  });
  test("Should call SaveSecureCacheStorage with correct value", () async {

    await sut.save(account);

    verify(secureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test("Should throw if SaveSecureCacheStorage throws", () async {

    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
