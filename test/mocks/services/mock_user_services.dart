import 'dart:async';

import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/services/user_services.dart';

class MockUserServices implements UserServices {

  static const existingEmail = 'a@b.com';
  static const existingUserId = 'uid_a@b.com';

  String? email;
  String? name;
  String? password;

  Map<String, String> emailToId = <String, String>{ existingEmail :  existingUserId  };


  @override
  Future<CreateUserResponse> createUser(CreateUserRequest request) {
    var c = Completer<CreateUserResponse>();
    if (request.password.contains('bad')) {
      c.complete(CreateUserResponse(false, message: 'bad password', reference: 'createFailed'));
    } else {
      emailToId[request.email] = 'uid_' + request.email;
      c.complete(CreateUserResponse(true, userId: 'uid_' + request.email));
    }
    return c.future;
  }

  @override
  Future<ValidateUserResponse> validateUser(ValidateUserRequest request) {
    var c = Completer<ValidateUserResponse>();
    if (request.email.contains('bademail.com')) {
      c.complete(ValidateUserResponse(false, reference: duplicateUser));
    } else {
      c.complete(ValidateUserResponse(true));
    }
    return c.future;
  }

  @override
  Future<LoginResponse> login(LoginRequest request) {
    var c = Completer<LoginResponse>();
    email = request.email;
    password = request.password;

    if (emailToId.keys.contains(request.email)) {
      c.complete(LoginResponse(true, userId: emailToId[request.email] ?? ''));
    } else {
      c.complete(LoginResponse(false));
    }

    return c.future;
  }
}
