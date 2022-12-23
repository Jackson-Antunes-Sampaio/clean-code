
import 'package:curso_clean_solid/main/factories/factories.dart';
import 'package:curso_clean_solid/validation/validators/validators.dart';
import 'package:test/test.dart';

void main(){
  test('Should return the correct validation', (){
    final validations = makeSignUpValidations();
    
    expect(validations, [
      RequiredFieldValidation(field: 'name'),
      const MinLengthValidation(field: 'name', size: 3),

      RequiredFieldValidation(field: 'email'),
      EmailValidation(field: 'email'),

      RequiredFieldValidation(field: 'password'),
      const MinLengthValidation(field: 'password', size: 3),

      RequiredFieldValidation(field: 'passwordConfirmation'),
      CompareFieldsValidation(field: 'passwordConfirmation',
          fieldToCompare: 'password')
    ]);
  });
}