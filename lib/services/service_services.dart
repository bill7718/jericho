import 'dart:async';

import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/service/service_item.dart';
import 'package:jericho/journeys/validators.dart';
import 'package:jericho/services/data_service.dart';
import 'package:jericho/services/liturgy_services.dart';
import 'package:jericho/services/presentation_services.dart';
import 'package:jericho/services/you_tube_services.dart';
import 'package:jericho/widgets/widgets_vm.dart';

class ServiceServices {
  static const String _serviceCollectionName = 'Service';

  static const String _nameFieldName = 'name';
  static const String _organisationIdFieldName = 'organisationId';
  static const String _serviceElementsFieldName = 'serviceElements';

  final DataService _data;
  final LiturgyServices _liturgy;
  final YouTubeServices _youTube;
  final PresentationServices _presentation;

  ServiceServices(this._data, this._liturgy, this._youTube, this._presentation);

  Future<CheckServiceResponse> checkService(CheckServiceRequest request) async {
    var c = Completer<CheckServiceResponse>();

    if (request.organisationId.isEmpty || request.name.isEmpty) {
      throw ServiceServicesException('Invalid request - ${request.organisationId} ');
    }

    try {
      var list =
      await _data.query(_serviceCollectionName, field: _organisationIdFieldName, value: request.organisationId);
      for (var item in list) {
        if (item[_nameFieldName] == request.name) {
          c.complete(CheckServiceResponse(false, id: item[idFieldName]));
          return c.future;
        }
      }
      c.complete(CheckServiceResponse(true));
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }


  Future<GetAllServiceResponse> getAllService(GetAllServiceRequest request) async {
    var c = Completer<GetAllServiceResponse>();
    try {
      if (request.organisationId.isEmpty ) {
        throw ServiceServicesException('Invalid request - ${request.organisationId} ');
      }

      var list = await _data.query(_serviceCollectionName, field:_organisationIdFieldName, value: request.organisationId );
      var serviceItems = <ServiceElement>[];
      for (var item in list) {
        serviceItems.add(ServiceElement(item[_serviceElementsFieldName]));
      }

      c.complete(GetAllServiceResponse(true, data: serviceItems));

    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }


  Future<CreateServiceResponse> createService(CreateServiceRequest request) async {
    var c = Completer<CreateServiceResponse>();
    try {

      if (request.organisationId.isEmpty || request.name.isEmpty || request.serviceElements.isEmpty ) {
        throw ServiceServicesException('Invalid request - ${request.organisationId} - ${request.name} - ${request.serviceElements}');
      }

      var checkResponse = await checkService(CheckServiceRequest(request.organisationId, request.name));
      if (checkResponse.valid) {

        var serviceContents = <String>[];
        for (var item in request.serviceElements) {
          serviceContents.add(item.element);
        }

        var id = await _data.set(_serviceCollectionName, {
          _organisationIdFieldName : request.organisationId,
          _nameFieldName: request.name,
          _serviceElementsFieldName: serviceContents
        });
        c.complete(CreateServiceResponse(true, id: id));
      } else {
        c.complete(CreateServiceResponse(false));
      }

    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }

  Future<GetServiceResponse> getService(GetServiceRequest request) async {
    var c = Completer<GetServiceResponse>();
    try {
      if (request.id.isEmpty ) {
        throw ServiceServicesException('Invalid request - ${request.id} ');
      }
      var service = await _data.get(_serviceCollectionName, request.id );

      var list = service[_serviceElementsFieldName];
      var serviceElements = <ServiceElement>[];
      for (var element in list) {
        serviceElements.add(ServiceElement(element));
      }

      var r = await getServiceContent(GetServiceContentRequest(serviceElements));

      c.complete(GetServiceResponse(true, serviceContents: r.serviceContents));


    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }

  Future<GetServiceContentResponse> getServiceContent(GetServiceContentRequest request) async {
    var c = Completer<GetServiceContentResponse>();
    try {
      if (request.serviceElements.isEmpty ) {
        throw ServiceServicesException('Invalid request - ${request.serviceElements} ');
      }

      var contents = <ServiceItem>[];

      for (var serviceElement in request.serviceElements) {
        if (serviceElement.type == LiturgyServices.liturgyCollectionName) {
          var data = await _liturgy.getLiturgy(GetLiturgyRequest(id: serviceElement.id));
          data.map['type'] = serviceElement.type;
          contents.add(ServiceItem(data.map));
        }
      }

      c.complete(GetServiceContentResponse(true, serviceContents: contents));

    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }

  Future<GetAllServiceItemsResponse> getAllServiceItems(GetAllServiceItemsRequest request) async {
    var c = Completer<GetAllServiceItemsResponse>();
    try {
      if (request.organisationId.isEmpty ) {
        throw ServiceServicesException('Invalid request - ${request.organisationId} ');
      }

      var data = <ServiceItem>[];

      var allLiturgy = await _liturgy.getAllLiturgy(GetAllLiturgyRequest(organisationId: request.organisationId));
      for (var item in allLiturgy.data) {
        item['type'] = allLiturgy.type;
        data.add(ServiceItem(item));
      }


      var allYoutube = await _youTube.getAllYouTube(GetAllYouTubeRequest(organisationId: request.organisationId));
      for (var item in allYoutube.data) {
        item['type'] = allYoutube.type;
        data.add(ServiceItem(item));
      }


      var allPresentation = await _presentation.getAllPresentation(GetAllPresentationRequest(organisationId: request.organisationId));
      for (var item in allPresentation.data) {
        item['type'] = allPresentation.type;
        data.add(ServiceItem(item));
      }

      c.complete(GetAllServiceItemsResponse(true, data: data));
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }

}




abstract class ServiceServiceResponse {
  final bool valid;
  final String message;
  final String reference;

  ServiceServiceResponse(this.valid, {this.message = '', this.reference = ''});
}

class GetAllServiceRequest {
  final String organisationId;

  GetAllServiceRequest({required this.organisationId});
}

class GetAllServiceResponse extends ServiceServiceResponse {

  final List<ServiceElement> data;

  GetAllServiceResponse(bool valid, {required this.data, String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class CheckServiceRequest {
  final String organisationId;
  final String name;

  CheckServiceRequest(this.organisationId, this.name);
}

class CheckServiceResponse extends ServiceServiceResponse {
  CheckServiceResponse(bool valid, { String id = '', String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class CreateServiceRequest {
  final String organisationId;
  final String name;
  final List<ServiceElement> serviceElements;

  CreateServiceRequest(this.organisationId, this.name, this.serviceElements);
}

class CreateServiceResponse extends ServiceServiceResponse {

  final String id;

  CreateServiceResponse(bool valid, { this.id = '', String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class GetServiceRequest {
  final String id;
  GetServiceRequest(this.id);
}

class GetServiceResponse extends ServiceServiceResponse {

  final String name;
  final List<ServiceItem> serviceContents;

  GetServiceResponse(bool valid, { this.name = '', this.serviceContents = const [],  String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class GetServiceContentRequest {
  final List<ServiceElement> serviceElements;
  GetServiceContentRequest(this.serviceElements);
}

class GetServiceContentResponse extends ServiceServiceResponse {

  final List<ServiceItem> serviceContents;

  GetServiceContentResponse(bool valid, { this.serviceContents = const [],  String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class GetAllServiceItemsRequest {
  final String organisationId;

  GetAllServiceItemsRequest({required this.organisationId});
}

class GetAllServiceItemsResponse extends ServiceServiceResponse {

  final List<ServiceItem> data;

  GetAllServiceItemsResponse(bool valid, {required this.data, String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class ServiceServicesException implements Exception {
  final String _message;

  ServiceServicesException(this._message);

  @override
  String toString() => _message;
}

class ServiceValidator {

  static const String nameError = 'serviceNameError';

  final ErrorMessageGetter _getter;

  ServiceValidator(this._getter);

  String? validateServiceName(String? name) {
    var n = name ?? '';

    if (n.isEmpty) {
      return _getter.getErrorMessage(nameError);
    }

    return null;
  }

}

///
/// A wrapper around a String that contains the Service item type and the id
/// separated by a "/" character
///
/// This constitutes the reference for the object that contains the data for this ServiceElement on the database
///
class ServiceElement  implements NamedItem {

  final String element;

  ServiceElement(this.element);

  @override
  String get type=> element.split('/').first;
  String get id=> element.split(':').first.split('/').last;
  @override
  String get name=> element.split(':').last;

  String get serviceItemRef => element.split(':').first;

}