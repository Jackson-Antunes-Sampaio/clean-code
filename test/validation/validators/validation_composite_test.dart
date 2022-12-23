
import 'package:curso_clean_solid/presentation/protocols/protocols.dart';
import 'package:curso_clean_solid/validation/protocols/field_validation.dart';
import 'package:curso_clean_solid/validation/validators/validators.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';


class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;
  late ValidationComposite sut;

  void mockValdiation1(ValidationError? error) {
    when(validation1.validation({'any_field' : 'any_value'})).thenReturn(error);
  }

  void mockValdiation2(ValidationError? error) {
    when(validation2.validation({'any_field' : 'any_value'})).thenReturn(error);
  }

  void mockValdiation3(ValidationError? error) {
    when(validation3.validation({'any_field' : 'any_value'})).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('any_field');
    mockValdiation1(null);

    validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    mockValdiation2(null);

    validation3 = FieldValidationSpy();
    when(validation3.field).thenReturn('other_field');
    mockValdiation3(null);

    sut = ValidationComposite(
        validations: [validation1, validation2, validation3]);
  });

  test('Should return null if all valdiations returns null or empty', () {

    final error = sut.validate(field: 'any_field', input:{'any_field' : 'any_value'});

    expect(error, null);
  });

  test('Should return the first error', () {
    mockValdiation1(ValidationError.requiredField);
    mockValdiation2(ValidationError.requiredField);
    mockValdiation3(ValidationError.invalidField);

    final error = sut.validate(field: 'any_field', input: {'any_field' : 'any_value'});

    expect(error, ValidationError.requiredField);
  });

}
