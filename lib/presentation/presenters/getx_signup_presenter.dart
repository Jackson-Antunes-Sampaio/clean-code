import '../../ui/helpers/errors/errors.dart';
import 'package:get/get.dart';

import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usercases/usercases.dart';
import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter{
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  String? _email;
  String? _name;
  String? _password;
  String? _passwordConfirmation;

  final _emailError = Rxn<UIError>();
  final _nameError = Rxn<UIError>();
  final _passwordError = Rxn<UIError>();
  final _passwordConfirmationError = Rxn<UIError>();
  final _mainError = Rxn<UIError>();
  final _isFormValid = false.obs;
  final _isLoading = false.obs;
  final _navigateTo = RxnString();

  @override
  Stream<UIError?>? get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError?>? get nameErrorStream => _nameError.stream;

  @override
  Stream<UIError?>? get passwordErrorStream => _passwordError.stream;

  @override
  Stream<UIError?>? get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;

  @override
  Stream<UIError?>? get mainErrorStream => _mainError.stream;

  @override
  Stream<bool?>? get isFormValidStream => _isFormValid.stream;

  @override
  Stream<bool?>? get isLoadingStream => _isLoading.stream;

  @override
  Stream<String?>? get navigateToStream => _navigateTo.stream;

  GetxSignUpPresenter(
      {required this.validation,
      required this.addAccount,
      required this.saveCurrentAccount});

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validationForm();
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validationForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validationForm();
  }

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordError.value =
        _validateField('password');
    _validationForm();
  }

  void _validationForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _nameError.value == null &&
        _email != null &&
        _name != null &&
        _passwordConfirmation != null &&
        _password != null;
  }

  UIError? _validateField(String? field) {
    final formData = {
      'email' : _email,
      'password' : _password,
      'passwordConfirmation' : _passwordConfirmation,
      'name' : _name
    };
    final error = validation.validate(field: field ?? '', input: formData);
    switch (error) {
      case ValidationError.requiredField:
        return UIError.invalidField;
      case ValidationError.invalidField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  @override
  Future signUp() async {
    try {
      _isLoading.value = true;
      _mainError.value = null;
      final account = await addAccount.add(
          params: AddAccountParams(
        email: _email!,
        password: _password!,
        name: _name!,
        passwordConfirmation: _passwordConfirmation!,
      ));
      await saveCurrentAccount.save(account!);
      _navigateTo.value = '/surveys';
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.emailInUser:
          _mainError.value = UIError.emailInUser;
          break;
        default:
          _mainError.value = UIError.unexpected;
          break;
      }
      _isLoading.value = false;
    }
  }

  @override
  Future<void> goToLogin() async{
    _navigateTo.value = '/login';
  }

  @override
  void dispose() {}
}
