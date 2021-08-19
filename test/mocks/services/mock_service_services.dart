import 'dart:async';
import 'package:jericho/services/service_services.dart';

class MockServiceServices implements ServiceServices {
  static const String existingService = 'alreadyHere';

  static const List<Map<String, dynamic>> serviceItems = [
    {'name': 'Hello', 'type': 'Liturgy', 'text': 'one two three', 'id': 'abc1234'}
  ];

  List<dynamic> requests = [];

  ///
  /// completes with [true] unless the service name is [existingService]
  ///
  @override
  Future<CheckServiceResponse> checkService(CheckServiceRequest request) {
    var c = Completer<CheckServiceResponse>();
    requests.add(request);

    if (request.organisationId.isEmpty || request.name.isEmpty) {
      throw ServiceServicesException('Invalid request - ${request.organisationId} ');
    }

    if (request.name == existingService) {
      c.complete(CheckServiceResponse(false));
    } else {
      c.complete(CheckServiceResponse(true));
    }
    return c.future;
  }

  @override
  Future<CreateServiceResponse> createService(CreateServiceRequest request) {
    var c = Completer<CreateServiceResponse>();
    requests.add(request);
    if (request.organisationId.isEmpty || request.name.isEmpty || request.serviceContents.isEmpty) {
      throw ServiceServicesException(
          'Invalid request - ${request.organisationId} - ${request.name} - ${request.serviceContents}');
    }

    c.complete(CreateServiceResponse(true, id: 'abc12345'));

    return c.future;
  }

  @override
  Future<GetAllServiceResponse> getAllService(GetAllServiceRequest request) {
    // TODO: implement getAllService
    throw UnimplementedError();
  }

  @override
  Future<GetAllServiceItemsResponse> getAllServiceItems(GetAllServiceItemsRequest request) {
    var c = Completer<GetAllServiceItemsResponse>();
    requests.add(request);
    if (request.organisationId.isEmpty) {
      throw ServiceServicesException('Invalid request - ${request.organisationId} ');
    }

    c.complete(GetAllServiceItemsResponse(true, data: serviceItems));

    return c.future;
  }

  @override
  Future<GetServiceResponse> getService(GetServiceRequest request) {
    // TODO: implement getService
    throw UnimplementedError();
  }

  @override
  Future<GetServiceContentResponse> getServiceContent(GetServiceContentRequest request) {
    // TODO: implement getServiceContent
    throw UnimplementedError();
  }
}
