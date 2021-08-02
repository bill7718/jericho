import 'package:email_validator/email_validator.dart';

class Validator {

  static const String nameError = 'nameError';
  static const String emailError = 'emailError';

  final ErrorMessageGetter _getter;

  Validator(this._getter);

  String? validateName(String? name) {
    var n = name ?? '';

    if (n.isEmpty) {
      return _getter.getErrorMessage(nameError);
    }

    return null;
  }

  String? validateEmail(String? email) {
    var e = email ?? '';

    if (e.isEmpty) {
      return _getter.getErrorMessage(emailError);
    }

    if (!EmailValidator.validate(e)) {
      return _getter.getErrorMessage(emailError);
    }

    return null;
  }
}

abstract class ErrorMessageGetter {

  String getErrorMessage(String id);
}