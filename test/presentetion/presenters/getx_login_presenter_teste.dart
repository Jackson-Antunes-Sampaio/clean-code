import 'package:curso_clean_solid/ui/helpers/errors/errors.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curso_clean_solid/domain/entities/entities.dart';
import 'package:curso_clean_solid/domain/helpers/helpers.dart';
import 'package:curso_clean_solid/domain/usercases/usercases.dart';
import 'package:curso_clean_solid/presentation/presenters/presenters.dart';
import 'package:curso_clean_solid/presentation/protocols/protocols.dart';




class ValidationSpy extends Mock implements Validation {}
class AuthenticationSpy extends Mock implements Authentication{}
class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount{}

void main() {
  late GetxLoginPresenter sut;
  late ValidationSpy validation;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late String email;
  late String password;
  late String token;
  late AuthenticationSpy authentication;

  When mockValidationCall({String? field}) {
    return when(validation.validate(field: field ?? 'email', input: {}));
  }

  void mockValidation({String? field, ValidationError? value}) {
    mockValidationCall(field: field).thenReturn(value);
  }


  When mockAuthenticationCall() {
    return when(authentication.auth(params: AuthenticationParams(email: email, secret: password)));
  }

  void mockAuthentication () {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));
  }

  When mockSaveCurrentAccountCall() {
    return when(saveCurrentAccount.save(AccountEntity(token)));
  }

  void saveCurrentAccountError () {
    mockSaveCurrentAccountCall().thenAnswer((_) async => DomainError.unexpected);
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount
    );
    email = faker.internet.email();
    token = faker.guid.guid();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
  });

  test('Should call validation with correct email', () {
    final formData = {'email' : email, 'password': null};

    sut.validateEmail(email);

    verify(validation.validate(field: 'email', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream
        ?.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream
        ?.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation success', () {
    sut.emailErrorStream?.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call validation with correct password', () {
    sut.validatePassword(password);
    final formData = {'email' : null, 'password': password};
    verify(validation.validate(field: 'password', input: formData)).called(1);
  });

  test('Should emit requiredFieldError if password is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });


  test('Should emit null if validation success', () {

    sut.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });


  test('Should disable form button if any field is invalid', () {
    mockValidation(field: 'email', value: ValidationError.invalidField);


    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should enable form button if any field are valid', () async{

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct value', () async{

    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();

    verify(authentication.auth(params: AuthenticationParams(email: email, secret: password))).called(1);

  });

  test('Should call SaveCurrentAccount  with correct value', () async{

    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);

  });

  test('Should emit Unexpectedcorrect if SaveCurrentAccount fails', () async{
    saveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream?.listen((event) => expect(event, UIError.unexpected));

    await sut.auth();

  });

  test('Should emit correct events on Authentication success', () async{

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();

  });

  test('Should change page on success', () async{

    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream?.listen((page) => expect(page, '/surveys.'));

    await sut.auth();

  });

  test('Should emit correct events on InvalidCredentialsError', () async{
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream?.listen((event) => expect(event, UIError.invalidCredentials));

    await sut.auth();

  });

  test('Should emit correct events on UnexpectedError', () async{
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream?.listen((event) => expect(event, UIError.unexpected));

    await sut.auth();

  });

  test('Should go to SignUpPage on link click', () async{

    sut.navigateToStream?.listen((page) => expect(page, '/signup'));

    sut.goToSignUp();
  });


}
