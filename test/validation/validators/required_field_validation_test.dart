
import 'package:curso_clean_solid/presentation/protocols/protocols.dart';
import 'package:test/test.dart';

import 'package:curso_clean_solid/validation/validators/validators.dart';






void main(){
  RequiredFieldValidation? sut;


  setUp((){
    sut = RequiredFieldValidation(field: 'any_field');
  });

  test('should return null is not empty', (){
    expect(sut!.validation({'any_field' : 'any_value'}), null);
  });

  test('should return error if value is empty', (){
    expect(sut!.validation({'any_field' : ''}), ValidationError.requiredField);
  });

  test('should return error if value is null', (){
    expect(sut!.validation({'any_field' : null}), ValidationError.requiredField);
  });
}