// import 'package:faker/faker.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:curso_clean_solid/domain/entities/entities.dart';
// import 'package:curso_clean_solid/domain/helpers/helpers.dart';
// import 'package:curso_clean_solid/domain/usercases/usercases.dart';
// import 'package:curso_clean_solid/presentation/presenters/presenters.dart';
// import 'package:curso_clean_solid/presentation/protocols/protocols.dart';
//
//
//
//
// class ValidationSpy extends Mock implements Validation {}
// class AuthenticationSpy extends Mock implements Authentication{}
//
// void main() {
//   late StreamLoginPresenter sut;
//   late ValidationSpy validation;
//   late String email;
//   late String password;
//   late AuthenticationSpy authentication;
//
//   When mockValidationCall({String? field}) {
//     return when(validation.validate(field: field ?? 'email', value: email));
//   }
//
//   void mockValidation({String? field, String? value}) {
//     mockValidationCall(field: field).thenReturn(value);
//   }
//
//
//   When mockAuthenticationCall() {
//     return when(authentication.auth(params: AuthenticationParams(email: email, secret: password)));
//   }
//
//   void mockAuthentication() {
//     mockAuthenticationCall().thenAnswer((_) async => AccountEntity(faker.guid.guid()));
//   }
//
//   void mockAuthenticationError(DomainError error) {
//     mockAuthenticationCall().thenThrow(error);
//   }
//
//   setUp(() {
//     validation = ValidationSpy();
//     authentication = AuthenticationSpy();
//     sut = StreamLoginPresenter(validation: validation, authentication: authentication);
//     email = faker.internet.email();
//     password = faker.internet.password();
//     mockValidation();
//     mockAuthentication();
//   });
//
//   test('Should call validation with correct email', () {
//     sut.validateEmail(email);
//
//     verify(validation.validate(field: 'email', value: email)).called(1);
//   });
//
//   test('Should email error if validation fails', () {
//     mockValidation(value: 'error');
//
//     sut.emailErrorStream
//         ?.listen(expectAsync1((error) => expect(error, 'error')));
//     sut.isFormValidStream
//         ?.listen(expectAsync1((isValid) => expect(isValid, false)));
//
//     sut.validateEmail(email);
//     sut.validateEmail(email);
//   });
//
//   test('Should emit null if validation success', () {
//     sut.emailErrorStream?.listen(expectAsync1((error) => expect(error, null)));
//     sut.isFormValidStream
//         ?.listen(expectAsync1((isValid) => expect(isValid, false)));
//
//     sut.validateEmail(email);
//     sut.validateEmail(email);
//   });
//
//   test('Should call validation with correct password', () {
//     sut.validatePassword(password);
//
//     verify(validation.validate(field: 'password', value: password)).called(1);
//   });
//
//   test('Should password error if validation fails', () {
//     mockValidation(value: 'error');
//
//     sut.passwordErrorStream
//         ?.listen(expectAsync1((error) => expect(error, 'error')));
//     sut.isFormValidStream
//         ?.listen(expectAsync1((isValid) => expect(isValid, false)));
//
//     sut.validatePassword(password);
//     sut.validatePassword(password);
//   });
//
//   test('Should emit null if validation success', () {
//
//     sut.passwordErrorStream
//         ?.listen(expectAsync1((error) => expect(error, null)));
//     sut.isFormValidStream
//         ?.listen(expectAsync1((isValid) => expect(isValid, false)));
//
//     sut.validatePassword(password);
//     sut.validatePassword(password);
//   });
//
//
//   test('Should emit null if validation success', () {
//     mockValidation(field: 'email', value: 'error');
//
//     sut.emailErrorStream
//         ?.listen(expectAsync1((error) => expect(error, 'error')));
//     sut.passwordErrorStream
//         ?.listen(expectAsync1((error) => expect(error, null)));
//     sut.isFormValidStream
//         ?.listen(expectAsync1((isValid) => expect(isValid, false)));
//
//     sut.validateEmail(email);
//     sut.validatePassword(password);
//   });
//
//   test('Should emit null if validation success', () async{
//
//     sut.emailErrorStream
//         ?.listen(expectAsync1((error) => expect(error, null)));
//     sut.passwordErrorStream
//         ?.listen(expectAsync1((error) => expect(error, null)));
//
//
//     expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
//
//     sut.validateEmail(email);
//     await Future.delayed(Duration.zero);
//     sut.validatePassword(password);
//   });
//
//   test('Should call Authentication with correct value', () async{
//
//     sut.validateEmail(email);
//     sut.validatePassword(password);
//     await sut.auth();
//
//     verify(authentication.auth(params: AuthenticationParams(email: email, secret: password))).called(1);
//
//   });
//
//   test('Should emit correct events on Authentication success', () async{
//
//     sut.validateEmail(email);
//     sut.validatePassword(password);
//
//     expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
//
//     await sut.auth();
//
//   });
//
//   test('Should emit correct events on InvalidCredentialsError', () async{
//     mockAuthenticationError(DomainError.invalidCredentials);
//     sut.validateEmail(email);
//     sut.validatePassword(password);
//
//     expectLater(sut.isLoadingStream, emits(false));
//     sut.mainErrorStream?.listen((event) => expect(event, 'Credenciais inválidas.'));
//
//     await sut.auth();
//
//   });
//
//   test('Should emit correct events on UnexpectedError', () async{
//     mockAuthenticationError(DomainError.unexpected);
//     sut.validateEmail(email);
//     sut.validatePassword(password);
//
//     expectLater(sut.isLoadingStream, emits(false));
//     sut.mainErrorStream?.listen((event) => expect(event, 'Algo errado aconteceu. Tente novamente em breve.'));
//
//     await sut.auth();
//
//   });
//
//   test('Should not emit after dispose', () async{
//     expectLater(sut.emailErrorStream, neverEmits(null));
//
//     sut.dispose();
//
//     sut.validateEmail(email);
//
//   });
//
// }
