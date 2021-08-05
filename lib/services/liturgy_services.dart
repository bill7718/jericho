
import 'dart:async';

import 'package:jericho/services/data_service.dart';

class LiturgyServices {

  static const String _liturgyCollectionName = 'Liturgy';

  static const String _nameFieldName = 'name';
  static const String _textFieldName = 'text';
  static const String _organisationIdFieldName = 'organisationId';

  final DataService _data;

  LiturgyServices(this._data);

  Future<GetLiturgyResponse> getLiturgy(GetLiturgyRequest request) async {
    var c = Completer<GetLiturgyResponse>();

    try {
      if (request.id.isNotEmpty) {
        var data = await _data.get(_liturgyCollectionName, request.id);
        c.complete(GetLiturgyResponse(true, id: request.id, name: data[_nameFieldName], text: data[_textFieldName]));
      } else {
        if (request.organisationId.isEmpty || request.name.isEmpty) {
          throw LiturgyServicesException('Invalid request - ${request.organisationId} - ${request.name}');
        }
        var list = await _data.query(_liturgyCollectionName, field:_organisationIdFieldName, value: request.organisationId );
        if (list.isEmpty) {
          c.complete(GetLiturgyResponse(false));
        } else {
          for (var item in list) {
            if (item[_nameFieldName] == request.name) {
              c.complete(GetLiturgyResponse(true, id: request.id, name: item[_nameFieldName], text: item[_textFieldName]));
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


  Future<CreateLiturgyResponse> createOrganisation(CreateLiturgyRequest request) async {
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
      var id = await _data.set(_liturgyCollectionName, liturgy);

      c.complete(CreateLiturgyResponse(true, id: id));
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
  final String id;
  final String name;
  final String text;

  GetLiturgyResponse(bool valid, {this.id = '', this.name = '', this.text= '', String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class LiturgyServicesException implements Exception {
  final String _message;

  LiturgyServicesException(this._message);

  @override
  String toString() => _message;
}