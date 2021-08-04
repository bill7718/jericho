import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/services/data_service.dart';
import 'package:jericho/services/firebase_service.dart';
import 'package:jericho/services/key_generator.dart';

class UserServices {
  static const String _userCollectionName = 'User';

  static const String _emailFieldName = 'email';
  static const String _nameFieldName = 'name';
  static const String _uidFieldName = 'uid';

  final DataService _data;
  final AuthenticationService _auth;

  UserServices(this._data, this._auth);

  ///
  /// Validates the requested User by checking that the
  /// - email address is in a valid format
  /// - email address is unique
  ///
  Future<ValidateUserResponse> validateUser(ValidateUserRequest request) async {
    var c = Completer<ValidateUserResponse>();
    try {
      if (request.email.isEmpty) {
        throw (UserServicesException('Email must not be empty'));
      }

      if (!EmailValidator.validate(request.email)) {
        throw (UserServicesException('Email must is a valid format ${request.email} '));
      }

      var l = await _data.query(_userCollectionName, field: _emailFieldName, value: request.email);
      if (l.isEmpty) {
        c.complete(ValidateUserResponse(true));
      } else {
        c.complete(ValidateUserResponse(false, message: 'Email is already in use', reference: 'duplicateUser'));
      }
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }

  Future<CreateUserResponse> createUser(CreateUserRequest request) async {
    var c = Completer<CreateUserResponse>();
    try {
      var r = await validateUser(request);
      if (r.valid) {
        var uid = await _auth.createUser(request.email, request.password);

        var m = <String, dynamic>{};
        m[_emailFieldName] = request.email;
        m[_nameFieldName] = request.name;
        m[_uidFieldName] = uid;

        var id = await _data.set(_userCollectionName , m);
        c.complete(CreateUserResponse(true, userId: id));
      } else {
        throw UserServicesException(r.message);
      }
    } catch (ex) {
      c.completeError(ex);
    }

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
  ValidateUserResponse(bool valid, {String message = '', String reference = ''}) : super(valid, message, reference);
}

abstract class CreateUserRequest implements ValidateUserRequest {
  String get name;
  String get email;
  String get password;
}

class CreateUserResponse extends UserServiceResponse {
  final String userId;

  CreateUserResponse(bool valid, {this.userId = '', String message = '', String reference = ''})
      : super(valid, message, reference);
}

class UserServicesException implements Exception {
  final String _message;

  UserServicesException(this._message);

  @override
  String toString() => _message;
}

abstract class AuthenticationService {
  Future<String> createUser(String email, String password);
}
