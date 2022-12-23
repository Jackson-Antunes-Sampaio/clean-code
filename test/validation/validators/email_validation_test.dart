
import 'package:curso_clean_solid/presentation/protocols/protocols.dart';
import 'package:curso_clean_solid/validation/validators/validators.dart';
import 'package:test/test.dart';



void main(){
  late EmailValidation sut;

  setUp((){
    sut = EmailValidation(field: 'any_field');
  });

  test('Should return null on invalid case', (){
    expect(sut.validation({}), null);
  });

  test('Should return null if email is empty', (){
    expect(sut.validation({'any_field' : ''}), null);
  });

  test('Should return null if email is null', (){
    expect(sut.validation({'any_field' : null}), null);
  });

  test('Should return null if email is valid', (){
    expect(sut.validation({'any_field' : 'jackson.sampaio@gmail.com'}), null);
  });

  test('Should return error if email is invalid', (){
    expect(sut.validation({'any_field' : 'jackson.sampaio'}), ValidationError.invalidField);
  });
}