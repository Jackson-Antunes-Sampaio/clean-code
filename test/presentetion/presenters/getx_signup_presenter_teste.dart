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

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late GetxSignUpPresenter sut;
  late ValidationSpy validation;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late String email;
  late String name;
  late String password;
  late String passwordConfirmation;
  late String token;
  late AddAccountSpy addAccount;

  When mockValidationCall({String? field}) {
    return when(validation.validate(field: field ?? 'email', input: {}));
  }

  void mockValidation({String? field, ValidationError? value}) {
    mockValidationCall(field: field).thenReturn(value);
  }

  When mockAddAccountCall() {
    return when(addAccount.add(
        params: AddAccountParams(
            email: email,
            password: password,
            name: name,
            passwordConfirmation: passwordConfirmation)));
  }

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));
  }

  When mockSaveCurrentAccountCall() {
    return when(saveCurrentAccount.save(AccountEntity(token)));
  }

  void saveCurrentAccountError() {
    mockSaveCurrentAccountCall()
        .thenAnswer((_) async => DomainError.unexpected);
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
        validation: validation,
        addAccount: addAccount,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    name = faker.person.name();
    token = faker.guid.guid();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    mockValidation();
    mockAddAccount();
  });

  test('Should call validation with correct email', () {
    sut.validateEmail(email);
    final formData = {
      'email' : email,
      'password': null,
      'name': null,
      'passwordConfirmation': null,
    };
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

  test('Should call validation with correct name', () {
    sut.validateName(name);
    final formData = {
      'email' : null,
      'password': null,
      'name': name,
      'passwordConfirmation': null,
    };
    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameErrorStream
        ?.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredFieldError if name is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.nameErrorStream
        ?.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation success', () {
    sut.nameErrorStream?.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call validation with correct password', () {
    sut.validatePassword(password);
    final formData = {
      'email' : null,
      'password': password,
      'name': null,
      'passwordConfirmation': null,
    };
    verify(validation.validate(field: 'name', input: formData)).called(1);
  });

  test('Should emit invalidFieldError if password is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
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

  test('Should call validation with correct passwordConfirmation', () {
    sut.validatePasswordConfirmation(passwordConfirmation);
    final formData = {
      'email' : null,
      'password': null,
      'name': null,
      'passwordConfirmation': passwordConfirmation,
    };
    verify(validation.validate(field: 'name', input: formData))
        .called(1);
  });

  test('Should emit invalidFieldError if passwordConfirmation is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordConfirmationErrorStream
        ?.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit requiredFieldError if passwordConfirmation is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream
        ?.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit null if validation success', () {
    sut.passwordConfirmationErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should enable form button if any field are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
  });

  test('Should call AddCount with correct value', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    await sut.signUp();

    verify(addAccount.add(
        params: AddAccountParams(
      email: email,
      passwordConfirmation: passwordConfirmation,
      name: name,
      password: password,
    ))).called(1);
  });

  test('Should call SaveCurrentAccount  with correct value', () async{

    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    await sut.signUp();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);

  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async{
    saveCurrentAccountError();

    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream?.listen((event) => expect(event, UIError.unexpected));

    await sut.signUp();

  });

  test('Should emit correct events on AddAccount success', () async{

    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.signUp();

  });

  test('Should emit correct events on InvalidCredentialsError', () async{
    mockAddAccountError(DomainError.emailInUser);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream?.listen((event) => expect(event, UIError.emailInUser));

    await sut.signUp();

  });

  test('Should emit correct events on UnexpectedError', () async{
    mockAddAccountError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream?.listen((event) => expect(event, UIError.unexpected));

    await sut.signUp();

  });

  test('Should change page on success', () async{

    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    sut.navigateToStream?.listen((page) => expect(page, '/surveys.'));

    await sut.signUp();

  });

  test('Should go to LoginPage on link click', () async{

    sut.navigateToStream?.listen((page) => expect(page, '/login'));

    sut.goToLogin();
  });
}
