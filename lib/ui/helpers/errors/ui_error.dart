import '../helpers.dart';

enum UIError{
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUser
}

extension UIErrorExtension on UIError{
  String get description {
    switch(this){
      case UIError.unexpected:
        return 'Algo errado aconteceu. Tente novamente em breve.';
      case UIError.invalidCredentials:
        return R.string.msgInvalidCredentials;
      case UIError.requiredField:
        return R.string.msgRequiredField;
      case UIError.invalidField:
        return R.string.msgInvalidField;
      case UIError.emailInUser:
        return R.string.msgEmailInUse;
    }
  }
}