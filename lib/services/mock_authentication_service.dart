

import 'dart:async';

import 'package:jericho/services/user_services.dart';

class MockAuthenticationService implements AuthenticationService {

  static const String preExistingUser = 'harry@already.com';

  Map<String, String> _users = <String, String>{};

  MockAuthenticationService() {
    _users[preExistingUser] = 'hello1234';
  }

  @override
  Future<String> createUser(String email, String password) {

    var c = Completer<String>();
    try {
      if (_users.keys.contains(email)) {
        throw Exception('duplicate user $email');
      }
      _users[email] = password;
      c.complete('uid_$email');

    } catch (ex) {
      c.completeError(ex);
    }


    return c.future;

  }

   @override
   Future<bool> login(String email, String password) {

    var c = Completer<bool>();

    if (_users.keys.contains(email)) {
      if (_users[email] == password) {
        c.complete(true);
      } else {
        c.completeError(Exception('Invalid password for $email : $password'));
      }
    } else {
      c.completeError(Exception('User not known $email'));
    }

    return c.future;
  }



}