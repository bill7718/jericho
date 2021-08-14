
import 'dart:async';

import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/validators.dart';
import 'package:jericho/services/data_service.dart';

///
/// Services for the Create, Update and Delete of Liturgy
///
class LiturgyServices {

  static const String liturgyCollectionName = 'Liturgy';

  static const String _nameFieldName = 'name';
  static const String _textFieldName = 'text';
  static const String _organisationIdFieldName = 'organisationId';

  final DataService _data;

  LiturgyServices(this._data);

  ///
  /// Retrieves liturgy if found
  /// Accepts either
  /// - an id
  /// - both an orgnisationId and a name
  ///
  /// If found then the response contains
  /// - valid = true
  /// - id
  /// - name
  /// - text
  ///
  /// If not found the response contains
  /// - valid = false
  ///  - all other fields are not populated
  ///
  Future<GetLiturgyResponse> getLiturgy(GetLiturgyRequest request) async {
    var c = Completer<GetLiturgyResponse>();

    try {
      if (request.id.isNotEmpty) {
        var data = await _data.get(liturgyCollectionName, request.id);
        c.complete(GetLiturgyResponse(true, map: data));
      } else {
        if (request.organisationId.isEmpty || request.name.isEmpty) {
          throw LiturgyServicesException('Invalid request - ${request.organisationId} - ${request.name}');
        }
        var list = await _data.query(liturgyCollectionName, field:_organisationIdFieldName, value: request.organisationId );
        if (list.isEmpty) {
          c.complete(GetLiturgyResponse(false));
        } else {
          for (var item in list) {
            if (item[_nameFieldName] == request.name) {
              c.complete(GetLiturgyResponse(true, map: item));
              return c.future;
            }
          }
          c.complete(GetLiturgyResponse(false));
        }
      }
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }


  Future<CreateLiturgyResponse> createLiturgy(CreateLiturgyRequest request) async {
    var c = Completer<CreateLiturgyResponse>();
    try {
      if (request.text.isEmpty || request.organisationId.isEmpty || request.name.isEmpty) {
        throw (LiturgyServicesException('Invalid request - ${request.organisationId} - ${request.name} - ${request.text}'));
      }

      var get = await getLiturgy(GetLiturgyRequest(organisationId: request.organisationId, name: request.name));

      if (get.valid) {
        throw (LiturgyServicesException('Liturgy Name is already in use - ${request.name}'));
      }

      var liturgy = <String, dynamic>{};
      liturgy[_nameFieldName] = request.name;
      liturgy[_organisationIdFieldName] = request.organisationId;
      liturgy[_textFieldName] = request.text;
      var id = await _data.set(liturgyCollectionName, liturgy);

      c.complete(CreateLiturgyResponse(true, id: id));
    } catch (ex) {
      c.completeError(ex);
    }

    return c.future;
  }

  Future<GetAllLiturgyResponse> getAllLiturgy(GetAllLiturgyRequest request) async {
    var c = Completer<GetAllLiturgyResponse>();
    try {
      if (request.organisationId.isEmpty ) {
        throw LiturgyServicesException('Invalid request - ${request.organisationId} ');
      }

      var list = await _data.query(liturgyCollectionName, field:_organisationIdFieldName, value: request.organisationId );

      c.complete(GetAllLiturgyResponse(true, data: list));
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }

}

abstract class LiturgyServiceResponse {
  final bool valid;
  final String message;
  final String reference;

  LiturgyServiceResponse(this.valid, {this.message = '', this.reference = ''});
}

class CreateLiturgyRequest  {
  final String organisationId;
  final String name;
  final String text;
  CreateLiturgyRequest(this.organisationId, this.name, this.text);
}

class CreateLiturgyResponse extends LiturgyServiceResponse {
  final String id;

  CreateLiturgyResponse(bool valid, {this.id = '', String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class GetLiturgyRequest {
  final String organisationId;
  final String name;
  final String id;
  GetLiturgyRequest({this.organisationId = '', this.name = '', this.id = ''});
}

class GetLiturgyResponse extends LiturgyServiceResponse {
  String get id => map[idFieldName];
  String get name => map[LiturgyServices._nameFieldName];
  String get text => map[LiturgyServices._textFieldName];
  final Map<String, dynamic> map;

  GetLiturgyResponse(bool valid, {this.map = const <String, dynamic>{}, String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class GetAllLiturgyRequest {
  final String organisationId;

  GetAllLiturgyRequest({required this.organisationId});
}

class GetAllLiturgyResponse extends LiturgyServiceResponse {

  final List<Map<String, dynamic>> data;
  final String type = LiturgyServices.liturgyCollectionName;

  GetAllLiturgyResponse(bool valid, {required this.data, String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class LiturgyServicesException implements Exception {
  final String _message;

  LiturgyServicesException(this._message);

  @override
  String toString() => _message;
}

class LiturgyValidator {

  static const String nameError = 'liturgyNameError';
  static const String contentError = 'liturgyContentError';

  final ErrorMessageGetter _getter;

  LiturgyValidator(this._getter);

  String? validateLiturgyName(String? name) {
    var n = name ?? '';

    if (n.isEmpty) {
      return _getter.getErrorMessage(nameError);
    }

    return null;
  }

  String? validateLiturgyContent(String? content) {
    var c = content ?? '';

    if (c.isEmpty) {
      return _getter.getErrorMessage(contentError);
    }

    return null;
  }

}