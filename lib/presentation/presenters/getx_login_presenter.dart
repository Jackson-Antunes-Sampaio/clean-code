import '../../ui/helpers/errors/errors.dart';
import 'package:get/get.dart';

import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usercases/usercases.dart';
import '../protocols/protocols.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String? _email;
  String? _password;

  final _emailError = Rxn<UIError>();
  final _passwordError = Rxn<UIError>();
  final _mainError = Rxn<UIError>();
  final _isFormValid = false.obs;
  final _isLoading = false.obs;
  final _navigateTo = RxnString();

  @override
  Stream<UIError?>? get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError?>? get passwordErrorStream => _passwordError.stream;

  @override
  Stream<UIError?>? get mainErrorStream => _mainError.stream;

  @override
  Stream<bool?>? get isFormValidStream => _isFormValid.stream;

  @override
  Stream<bool?>? get isLoadingStream => _isLoading.stream;

  @override
  Stream<String?>? get navigateToStream => _navigateTo.stream;

  GetxLoginPresenter(
      {required this.validation,
      required this.authentication,
      required this.saveCurrentAccount});

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validationForm();
  }

  void _validationForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        _validateField('password');
    _validationForm();
  }

  UIError? _validateField(String? field){
    final formData = {
      'email' : _email,
      'password' : _password
    };
    final error = validation.validate(field: field ?? '', input: formData);
    switch(error){
      case ValidationError.requiredField:
        return UIError.invalidField;
      case ValidationError.invalidField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  @override
  Future auth() async {

    try {
      _mainError.value = null;
      _isLoading.value = true;
     final account = await authentication.auth(
          params: AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(account!);
      _navigateTo.value = '/surveys';
    } on DomainError catch (e) {
      switch(e){
        case DomainError.unexpected:
          _mainError.value = UIError.unexpected;
          break;
        case DomainError.invalidCredentials:
          _mainError.value = UIError.invalidCredentials;
          break;
      }
      _isLoading.value = false;
    }

  }

  @override
  Future<void> goToSignUp() async{
    _navigateTo.value = '/signup';
  }


  @override
  void dispose() {}




}
