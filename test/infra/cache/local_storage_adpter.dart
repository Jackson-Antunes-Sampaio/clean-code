import 'package:curso_clean_solid/infra/http/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late LocalStorageAdapter sut;
  late FlutterSecureStorageSpy secureStorage;
  late String key;
  late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('saveSecure', () {
    void mockSaveSecureError() {
      when(secureStorage.write(key: 'any', value: 'value'))
          .thenThrow(Expectation);
    }

    test('Should call save secure correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value));
    });

    test('Should throw if call save secure throws', () async {
      mockSaveSecureError();

      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    When mockFetchSecureCall() => when(secureStorage.read(
          key: 'any',
        ));

    void mockFetchSecure() {
      mockFetchSecureCall().thenAnswer(((_) async => value));
    }

    void mockFetchSecureError() {
      mockFetchSecureCall().thenThrow(Expectation);
    }

    setUp(() {
      mockFetchSecure();
    });

    test('Should call fetch secure correct value', () async {
      await sut.fetchSecure(key);

      verify(() => secureStorage.read(key: key));
    });

    test('Should return current value on success', () async {
      final fetchValue = await sut.fetchSecure(key);

      expect(fetchValue, value);
    });

    test('Should throw if call fetch secure throws', () async {
      mockFetchSecureError();

      final future = sut.fetchSecure(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}
