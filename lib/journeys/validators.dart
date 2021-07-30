import 'package:email_validator/email_validator.dart';

const String nameError = 'Please provide a name';
const String emailError = 'Please provide a valid email address';


String? validateName(String name, { bool mandatory = true}) {

  if (name.isEmpty && mandatory) {
    return nameError;
  }

  return null;
}

String? validateEmail(String email, { bool mandatory = true}) {
  if (email.isEmpty && mandatory) {
    return emailError;
  }

  if (email.isNotEmpty) {
    if (!EmailValidator.validate(email)) {
      return emailError;
    }
  }

  return null;
}