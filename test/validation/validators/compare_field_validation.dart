import 'package:curso_clean_solid/presentation/protocols/validation.dart';
import 'package:curso_clean_solid/validation/validators/validators.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';



void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', fieldToCompare: 'other_field');
  });

  test('Should return null on invalid cases', () {

    expect(sut.validation({
      'any_field' : 'any_value',
    }), null);

    expect(sut.validation({
      'other_field' : 'other_value'
    }), null);

    expect(sut.validation({
    }), null);
  });

  test('Should return error if values are not equal', () {
    final formData = {
      'any_field' : 'any_value',
      'other_field' : 'other_value'
    };
    final value = sut.validation(formData);
    expect(value, ValidationError.invalidField);
  });

  test('Should return null if values are equal', () {
    final formData = {
      'any_field' : 'any_value',
      'other_field' : 'any_value'
    };
    expect(sut.validation(formData), null);
  });

}
