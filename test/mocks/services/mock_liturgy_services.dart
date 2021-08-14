

import 'dart:async';

import 'package:jericho/services/liturgy_services.dart';

class MockLiturgyServices implements LiturgyServices {

  static const String existingLiturgyName = 'alreadyHere';

  List<String> serviceCalls = <String>[];

  @override
  Future<CreateLiturgyResponse> createLiturgy(CreateLiturgyRequest request) {
    // TODO: implement createLiturgy
    throw UnimplementedError();
  }

  @override
  Future<GetAllLiturgyResponse> getAllLiturgy(GetAllLiturgyRequest request) {
    // TODO: implement getAllLiturgy
    throw UnimplementedError();
  }

  @override
  Future<GetLiturgyResponse> getLiturgy(GetLiturgyRequest request) {
    var c = Completer<GetLiturgyResponse>();
    serviceCalls.add('getLiturgy');
    if (request.name == existingLiturgyName) {
      c.complete(GetLiturgyResponse(true));
    } else {
      c.complete(GetLiturgyResponse(false));
    }

    return c.future;
  }


}