import 'dart:async';

import 'package:jericho/services/data_service.dart';

class ServiceServices {
  static const String _serviceCollectionName = 'Service';

  static const String _nameFieldName = 'name';
  static const String _organisationIdFieldName = 'organisationId';

  final DataService _data;

  ServiceServices(this._data);

  Future<CheckServiceResponse> checkYouTube(CheckServiceRequest request) async {
    var c = Completer<CheckServiceResponse>();
    try {
      var list =
      await _data.query(_serviceCollectionName, field: _organisationIdFieldName, value: request.organisationId);
      for (var item in list) {
        if (item[_nameFieldName] == request.name) {
          c.complete(CheckServiceResponse(false));
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

      c.complete(GetAllServiceResponse(true, data: list));
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

  final List<Map<String, dynamic>> data;

  GetAllServiceResponse(bool valid, {required this.data, String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class CheckServiceRequest {
  final String organisationId;
  final String name;

  CheckServiceRequest(this.organisationId, this.name);
}

class CheckServiceResponse extends ServiceServiceResponse {
  CheckServiceResponse(bool valid, {String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class ServiceServicesException implements Exception {
  final String _message;

  ServiceServicesException(this._message);

  @override
  String toString() => _message;
}
