

import 'dart:async';

import 'package:jericho/services/liturgy_services.dart';

class MockLiturgyServices implements LiturgyServices {

  static const String existingLiturgyName = 'alreadyHere';

  List<dynamic> requests =[];

  @override
  Future<CreateLiturgyResponse> createLiturgy(CreateLiturgyRequest request) {
    var c = Completer<CreateLiturgyResponse>();
    requests.add(request);
    if (request.name == existingLiturgyName) {
      c.completeError('Duplicate liturgy name');
      c.complete(CreateLiturgyResponse(false));
    } else {
      c.complete(CreateLiturgyResponse(true));
    }

    return c.future;
  }

  @override
  Future<GetAllLiturgyResponse> getAllLiturgy(GetAllLiturgyRequest request) {
    // TODO: implement getAllLiturgy
    throw UnimplementedError();
  }

  @override
  Future<GetLiturgyResponse> getLiturgy(GetLiturgyRequest request) {
    var c = Completer<GetLiturgyResponse>();
    requests.add(request);
    if (request.name == existingLiturgyName) {
      c.complete(GetLiturgyResponse(true));
    } else {
      c.complete(GetLiturgyResponse(false));
    }

    return c.future;
  }


}