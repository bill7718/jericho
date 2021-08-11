import 'dart:async';

import 'package:jericho/journeys/validators.dart';
import 'package:jericho/services/data_service.dart';

class YouTubeServices {
  static const String _youTubeCollectionName = 'YouTube';

  static const String _nameFieldName = 'name';
  static const String _organisationIdFieldName = 'organisationId';
  static const String _videoIdFieldName = 'videoId';

  final DataService _data;

  YouTubeServices(this._data);

  Future<CheckYouTubeResponse> checkYouTube(CheckYouTubeRequest request) async {
    var c = Completer<CheckYouTubeResponse>();
    try {
      var list =
          await _data.query(_youTubeCollectionName, field: _organisationIdFieldName, value: request.organisationId);
      for (var item in list) {
        if (item[_nameFieldName] == request.name) {
          c.complete(CheckYouTubeResponse(false));
          return c.future;
        }
      }
      c.complete(CheckYouTubeResponse(true));
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }

  Future<GetYouTubeResponse> getYouTube(GetYouTubeRequest request) async {
    var c = Completer<GetYouTubeResponse>();
    try {
      if (request.organisationId.isEmpty || request.id.isEmpty) {
        throw (YouTubeServicesException('Invalid request - ${request.organisationId} - ${request.id}'));
      }
      var data = await _data.get(_youTubeCollectionName, request.id);

      c.complete(GetYouTubeResponse(true, name: data[_nameFieldName]));
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }


  Future<CreateYouTubeResponse> createYouTube(CreateYouTubeRequest request) async {
    var c = Completer<CreateYouTubeResponse>();
    try {
      if (request.organisationId.isEmpty || request.name.isEmpty || request.videoId.isNotEmpty) {
        throw (YouTubeServicesException('Invalid request - ${request.organisationId} - ${request.name} - ${request.videoId}'));
      }

      var list = await _data.query(_youTubeCollectionName, field: _organisationIdFieldName, value: request.organisationId);
      for (var item in list) {
        if (item[_nameFieldName] == request.name) {
          throw (YouTubeServicesException('Invalid request duplicate video name - ${request.organisationId} - ${request.name}'));
        }
      }
      var id = await _data.set(_youTubeCollectionName, <String, dynamic> {
        _organisationIdFieldName: request.organisationId,
        _nameFieldName : request.name,
        _videoIdFieldName : request.videoId
      });

      c.complete(CreateYouTubeResponse(true, id: id));

    } catch (ex) {
      c.completeError(ex);
    }

    return c.future;
  }

  Future<GetAllYouTubeResponse> getAllPresentation(GetAllYouTubeRequest request) async {
    var c = Completer<GetAllYouTubeResponse>();
    try {
      if (request.organisationId.isEmpty ) {
        throw YouTubeServicesException('Invalid request - ${request.organisationId} ');
      }

      var list = await _data.query(_youTubeCollectionName, field:_organisationIdFieldName, value: request.organisationId );

      c.complete(GetAllYouTubeResponse(true, data: list));
    } catch (ex) {
      c.completeError(ex);
    }
    return c.future;
  }
}

abstract class YouTubeServiceResponse {
  final bool valid;
  final String message;
  final String reference;

  YouTubeServiceResponse(this.valid, {this.message = '', this.reference = ''});
}

class CheckYouTubeRequest {
  final String organisationId;
  final String name;

  CheckYouTubeRequest(this.organisationId, this.name);
}

class CheckYouTubeResponse extends YouTubeServiceResponse {
  CheckYouTubeResponse(bool valid, {String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class GetYouTubeRequest {
  final String organisationId;
  final String id;

  GetYouTubeRequest(this.organisationId, this.id);
}

class GetYouTubeResponse extends YouTubeServiceResponse {
  final String name;

  GetYouTubeResponse(bool valid, {this.name = '', String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class CreateYouTubeRequest  {
  final String organisationId;
  final String name;
  final String videoId;
  CreateYouTubeRequest(this.organisationId, this.name, this.videoId);
}

class CreateYouTubeResponse extends YouTubeServiceResponse {
  final String id;

  CreateYouTubeResponse(bool valid, {this.id = '', String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class GetAllYouTubeRequest {
  final String organisationId;

  GetAllYouTubeRequest({required this.organisationId});
}

class GetAllYouTubeResponse extends YouTubeServiceResponse {

  final List<Map<String, dynamic>> data;

  GetAllYouTubeResponse(bool valid, {required this.data, String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}


class YouTubeServicesException implements Exception {
  final String _message;

  YouTubeServicesException(this._message);

  @override
  String toString() => _message;
}

class YouTubeValidator {

  static const String nameError = 'youtubeNameError';
  static const String idError = 'youtubeIdError';

  final ErrorMessageGetter _getter;

  YouTubeValidator(this._getter);

  String? validateName(String? name) {
    var n = name ?? '';

    if (n.isEmpty) {
      return _getter.getErrorMessage(nameError);
    }

    return null;
  }

  String? validateVideoIdentifier(String? identifier) {
    var i = identifier ?? '';

    if (i.isEmpty) {
      return _getter.getErrorMessage(nameError);
    }

    return null;
  }

}