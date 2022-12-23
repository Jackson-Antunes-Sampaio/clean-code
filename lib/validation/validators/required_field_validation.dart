import 'package:equatable/equatable.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/field_validation.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation{
  @override
  String? field;

  @override
  List get props => [field];

  RequiredFieldValidation({ required this.field});

  @override
  ValidationError? validation(Map? input){
    return input?[field]?.isNotEmpty == true ? null : ValidationError.requiredField;
  }
}