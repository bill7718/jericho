import 'package:email_validator/email_validator.dart';

const String nameError = 'Please provide a name';
const String emailError = 'Please provide a valid email address';


String? validateName(String? name) {

  var n = makeNotNull(name);

  if (n.isEmpty) {
    return nameError;
  }

  return null;
}

String? validateEmail(String? email) {

  var e = makeNotNull(email);

  if (e.isEmpty) {
    return emailError;
  }

  if (!EmailValidator.validate(e)) {
    return emailError;
  }

  return null;
}

String makeNotNull(String? i)=>(i ?? '');