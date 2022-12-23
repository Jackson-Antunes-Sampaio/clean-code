import 'package:curso_clean_solid/domain/entities/account_entity.dart';
import 'package:curso_clean_solid/domain/usercases/load_current_account.dart';
import 'package:curso_clean_solid/presentation/presenters/presenters.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';


class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  @override
  Future<AccountEntity?> load() {
    // TODO: implement load
    throw UnimplementedError();
  }
}

void main() {
  late LoadCurrentAccountSpy loadCurrentAccount;
  late GetxSplashPresenter sut;

  When mockLoadCurrentAccountCall() => when(loadCurrentAccount.load());

  void mockLoadCurrentAccount({AccountEntity? account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount(durationSecond: 0);

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys on success', () async {
    sut.navigateToStream
        ?.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount(durationSecond: 0);
  });

  test('Should go to Login page on null result', () async {
    mockLoadCurrentAccount(account: null);
    sut.navigateToStream
        ?.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount(durationSecond: 0);
  });

  test('Should go to Login page on null token', () async {
    mockLoadCurrentAccount(account: const AccountEntity('null'));
    sut.navigateToStream
        ?.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount(durationSecond: 0);
  });

  test('Should go to Login page on error', () async {
    mockLoadCurrentAccountError();
    sut.navigateToStream
        ?.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.checkAccount(durationSecond: 0);
  });
}
