

import 'dart:async';

class UserServices {

  Future<ValidateUserResponse> validateUser(ValidateUserRequest request) {
    var c = Completer<ValidateUserResponse>();

    c.complete(ValidateUserResponse(true, message: 'Email is already in use', reference: 'duplicateUser'));
    return c.future;
  }

  Future<CreateUserResponse> createUser(CreateUserRequest request) {
    var c = Completer<CreateUserResponse>();

    c.complete(CreateUserResponse(true, '12345678'));
    return c.future;
  }



}

abstract class UserServiceResponse {

  final bool valid;
  final String message;
  final String reference;

  UserServiceResponse(this.valid, this.message, this.reference);
}


abstract class ValidateUserRequest {
  String get name;
  String get email;

}


class ValidateUserResponse extends UserServiceResponse {
  ValidateUserResponse( bool valid, {  String message = '', String reference = ''}) : super(valid, message, reference);

}

abstract class CreateUserRequest {

  String get name;
  String get email;
  String get password;

}

class CreateUserResponse extends UserServiceResponse {

  final String userId;

  CreateUserResponse( bool valid, this.userId, {  String message = '', String reference = ''}) : super(valid, message, reference);

}