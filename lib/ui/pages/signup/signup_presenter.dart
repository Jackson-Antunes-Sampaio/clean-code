import '../../helpers/errors/errors.dart';

abstract class SignUpPresenter{

  Stream<UIError?>? get emailErrorStream;
  Stream<UIError?>? get nameErrorStream;
  Stream<UIError?>? get passwordErrorStream;
  Stream<UIError?>? get passwordConfirmationErrorStream;
  Stream<bool?>? get isFormValidStream;
  Stream<bool?>? get isLoadingStream;
  Stream<UIError?>? get mainErrorStream;
  Stream<String?>? get navigateToStream;

  void validateEmail(String email);
  void validateName(String name);
  void validatePassword(String pass);
  void validatePasswordConfirmation(String passConfirmation);

  Future<void> signUp();
  Future<void> goToLogin();

  void dispose();

}