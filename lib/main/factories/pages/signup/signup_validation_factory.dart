import '../../../builders/builders.dart';
import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';


Validation makeSignUpValidation() {
  return ValidationComposite(
    validations: makeSignUpValidations(),
  );
}

List<FieldValidation> makeSignUpValidations() {
  return [
    ...ValidationBuilder.field('name').required().min(3).build(),
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
    ...ValidationBuilder.field('passwordConfirmation').required().sameAs('password').build(),
  ];
}
