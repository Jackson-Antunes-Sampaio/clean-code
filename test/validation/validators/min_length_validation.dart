import 'package:curso_clean_solid/presentation/protocols/validation.dart';
import 'package:curso_clean_solid/validation/validators/validators.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';



void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = const MinLengthValidation(field: 'any_field', size: 5);
  });

  test('Should return error if value empty', () {
    expect(sut.validation({'any_field' : ''}), ValidationError.invalidField);
  });

  test('Should return error if value null', () {
    expect(sut.validation({'any_field' : null}), ValidationError.invalidField);
  });

  test('Should return error if value is less than min size', () {
    expect(sut.validation({'any_field' : faker.randomGenerator.string(4, min: 1)}),
        ValidationError.invalidField);
  });

  test('Should return null if value is equal than min size', () {
    expect(sut.validation({'any_field' : faker.randomGenerator.string(5, min: 5)}),
        null);
  });

  test('Should return null if value is bigger than min size', () {
    expect(sut.validation({'any_field' : faker.randomGenerator.string(10, min: 6)}),
        null);
  });
}
