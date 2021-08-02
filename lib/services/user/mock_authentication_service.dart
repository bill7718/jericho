

import 'dart:async';

import 'package:jericho/services/user/user_services.dart';

class MockAuthenticationService implements AuthenticationService {

  static const String preExistingUser = 'harry@already.com';

  Map<String, String> _users = <String, String>{};

  MockAuthenticationService() {
    _users[preExistingUser] = 'hello123';
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



}