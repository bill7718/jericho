
import 'dart:async';

import 'package:jericho/services/presentation_services.dart';

class MockPresentationServices implements PresentationServices {

  static const existingName = 'alreadyHere';

  List<dynamic> requests =[];

  @override
  Future<CheckPresentationResponse> checkPresentation(CheckPresentationRequest request) {
   var c = Completer<CheckPresentationResponse>();
   requests.add(request);

   if (request.name == existingName) {
     c.complete(CheckPresentationResponse(false));
   } else {
     c.complete(CheckPresentationResponse(true));
   }

   return c.future;
  }

  @override
  Future<CreatePresentationResponse> createPresentation(CreatePresentationRequest request) {
    var c = Completer<CreatePresentationResponse>();
    requests.add(request);

    if (request.name == existingName) {
      c.complete(CreatePresentationResponse(false));
    } else {
      c.complete(CreatePresentationResponse(true, id: 'id_${request.name}'));
    }

    return c.future;
  }

  @override
  Future<GetAllPresentationResponse> getAllPresentation(GetAllPresentationRequest request) {
    // TODO: implement getAllPresentation
    throw UnimplementedError();
  }

  @override
  Future<GetPresentationResponse> getPresentation(GetPresentationRequest request) {
    // TODO: implement getPresentation
    throw UnimplementedError();
  }



}