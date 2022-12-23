// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import '../../ui/pages/pages.dart';
// import '../../domain/helpers/helpers.dart';
// import '../../domain/usercases/usercases.dart';
// import '../protocols/protocols.dart';
//
// class LoginState {
//   String? emailError;
//   String? passwordError;
//   String? email;
//   String? password;
//   String? mainError;
//   bool isLoading = false;
//
//   bool? get isFormValid {
//     final value = emailError == null &&
//         passwordError == null &&
//         email != null &&
//         password != null;
//     return value;
//   }
// }
//
// class StreamLoginPresenter implements LoginPresenter {
//   final Validation validation;
//   StreamController<LoginState>? _controller =
//       StreamController<LoginState>.broadcast();
//   final Authentication authentication;
//
//   final _state = LoginState();
//
//   @override
//   Stream<String?>? get emailErrorStream =>
//       _controller?.stream.map((event) => event.emailError).distinct();
//
//   @override
//   Stream<String?>? get passwordErrorStream =>
//       _controller?.stream.map((event) => event.passwordError).distinct();
//
//   @override
//   Stream<bool?>? get isFormValidStream => _controller?.stream.map((event) {
//         return event.isFormValid;
//       }).distinct();
//
//   @override
//   Stream<bool?>? get isLoadingStream =>
//       _controller?.stream.map((event) => event.isLoading).distinct();
//
//   @override
//   Stream<String?>? get mainErrorStream =>
//       _controller?.stream.map((event) => event.mainError).distinct();
//
//   StreamLoginPresenter(
//       {required this.validation, required this.authentication});
//
//   void update() => _controller?.add(_state);
//
//   @override
//   void validateEmail(String email) {
//     _state.email = email;
//     _state.emailError = validation.validate(field: 'email', value: email);
//     update();
//   }
//
//   @override
//   void validatePassword(String password) {
//     _state.password = password;
//     _state.passwordError =
//         validation.validate(field: 'password', value: password);
//     update();
//   }
//
//   @override
//   Future auth() async {
//
//     update();
//
//     try {
//       _state.isLoading = true;
//       await authentication.auth(
//           params: AuthenticationParams(
//               email: _state.email!, secret: _state.password!));
//     } on DomainError catch (e) {
//       _state.mainError = e.description;
//       _state.isLoading = false;
//     }
//
//
//     update();
//   }
//
//   @override
//   void dispose() {
//     _controller?.close();
//     _controller = null;
//   }
//
//   @override
//   // TODO: implement navigateToStream
//   Stream<String?>? get navigateToStream => throw UnimplementedError();
//
// }
