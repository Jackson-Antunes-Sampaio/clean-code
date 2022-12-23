import 'package:equatable/equatable.dart';

import '../../presentation/protocols/validation.dart';
import '../protocols/field_validation.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  @override
  final String? field;
  final int size;

  @override
  List get props => [field, size];

  const MinLengthValidation({required this.field, required this.size});

  @override
  ValidationError? validation(Map? input) {
    return input?[field] != null && input?[field]?.length >= size ? null :  ValidationError.invalidField;
  }
}