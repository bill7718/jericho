

import 'dart:async';
import 'dart:typed_data';

import 'package:jericho/journeys/validators.dart';
import 'package:jericho/services/data_service.dart';
import 'package:jericho/services/document_server_service.dart';

class PresentationServices {

  static const String _presentationCollectionName = 'Presentation';

  static const String _nameFieldName = 'name';
  static const String _organisationIdFieldName = 'organisationId';

  final DataService _data;
  final DocumentServerService _documents;

  PresentationServices(this._data, this._documents);

  Future<CreatePresentationResponse> createPresentation(CreatePresentationRequest request) async {
    var c = Completer<CreatePresentationResponse>();
    try {
      if (request.data.isEmpty || request.organisationId.isEmpty || request.name.isEmpty) {
        throw (PresentationServicesException('Invalid request - ${request.organisationId} - ${request.name} - ${request.data.length}'));
      }

      var list = await _data.query(_presentationCollectionName, field: _organisationIdFieldName, value: request.organisationId);
      for (var item in list) {
        if (item[_nameFieldName] == request.name) {
          throw (PresentationServicesException('Invalid request duplicate file name - ${request.organisationId} - ${request.name}'));
        }
      }
      var id = await _data.set(_presentationCollectionName, <String, dynamic> {
        _organisationIdFieldName: request.organisationId,
        _nameFieldName : request.name
      });
      await _documents.put(request.organisationId, id, request.data);

      c.complete(CreatePresentationResponse(true, id: id));

    } catch (ex) {
      c.completeError(ex);
    }

    return c.future;
  }

  Future<GetPresentationResponse> getPresentation(GetPresentationRequest request) async {
    var c = Completer<GetPresentationResponse>();
    try {
      if (request.organisationId.isEmpty || request.id.isEmpty) {
        throw (PresentationServicesException('Invalid request - ${request.organisationId} - ${request.id}'));
      }
      var data = await _documents.get(request.organisationId, request.id);
      c.complete(GetPresentationResponse(true, data: data));
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }

  Future<CheckPresentationResponse> checkPresentation(CheckPresentationRequest request) async {
    var c = Completer<CheckPresentationResponse>();
    try {
      var list = await _data.query(_presentationCollectionName, field: _organisationIdFieldName, value: request.organisationId);
      for (var item in list) {
        if (item[_nameFieldName] == request.name) {
          c.complete(CheckPresentationResponse(false));
          return c.future;
        }
      }
      c.complete(CheckPresentationResponse(true));
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }


  Future<GetAllPresentationResponse> getAllPresentation(GetAllPresentationRequest request) async {
    var c = Completer<GetAllPresentationResponse>();
    try {
      if (request.organisationId.isEmpty ) {
        throw PresentationServicesException('Invalid request - ${request.organisationId} ');
      }

      var list = await _data.query(_presentationCollectionName, field:_organisationIdFieldName, value: request.organisationId );

      c.complete(GetAllPresentationResponse(true, data: list));
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }
}

abstract class PresentationServiceResponse {
  final bool valid;
  final String message;
  final String reference;

  PresentationServiceResponse(this.valid, {this.message = '', this.reference = ''});
}

class CreatePresentationRequest  {
  final String organisationId;
  final String name;
  final Uint8List data;
  CreatePresentationRequest(this.organisationId, this.name, this.data);
}

class CreatePresentationResponse extends PresentationServiceResponse {
  final String id;

  CreatePresentationResponse(bool valid, {this.id = '', String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class GetPresentationRequest  {
  final String organisationId;
  final String id;

  GetPresentationRequest(this.organisationId, this.id);
}

class GetPresentationResponse extends PresentationServiceResponse {
  final Uint8List data;

  GetPresentationResponse(bool valid, { required this.data , String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class CheckPresentationRequest {

  final String organisationId;
  final String name;

  CheckPresentationRequest(this.organisationId, this.name);
}

class  CheckPresentationResponse extends PresentationServiceResponse {

  CheckPresentationResponse(bool valid, { String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class GetAllPresentationRequest {
  final String organisationId;

  GetAllPresentationRequest({required this.organisationId});
}

class GetAllPresentationResponse extends PresentationServiceResponse {

  final List<Map<String, dynamic>> data;

  GetAllPresentationResponse(bool valid, {required this.data, String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class PresentationServicesException implements Exception {
  final String _message;

  PresentationServicesException(this._message);

  @override
  String toString() => _message;
}

class PresentationValidator {

  static const String nameError = 'presentationNameError';

  final ErrorMessageGetter _getter;

  PresentationValidator(this._getter);

  String? validatePresentationName(String? name) {
    var n = name ?? '';

    if (n.isEmpty) {
      return _getter.getErrorMessage(nameError);
    }

    return null;
  }

}