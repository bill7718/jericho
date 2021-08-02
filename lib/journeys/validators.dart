import 'package:email_validator/email_validator.dart';

class Validator {

  static const String nameError = 'Please provide a name';
  static const String emailError = 'Please provide a valid email address';

  final ErrorMessageGetter _getter;

  Validator(this._getter);

  String? validateName(String? name) {
    var n = name ?? '';

    if (n.isEmpty) {
      return nameError;
    }

    return null;
  }

  String? validateEmail(String? email) {
    var e = email ?? '';

    if (e.isEmpty) {
      return emailError;
    }

    if (!EmailValidator.validate(e)) {
      return emailError;
    }

    return null;
  }
}

abstract class ErrorMessageGetter {

  String getErrorMessage(String id);
}