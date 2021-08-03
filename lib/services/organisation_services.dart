import 'dart:async';

import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/services/data_service.dart';

class OrganisationServices {
  static const String _organisationCollectionName = 'Organisation';
  static const String _organisationUserCollectionName = 'OrganisationUser';
  static const String _organisationInvitationCollectionName = 'OrganisationInvitation';

  static const String _nameFieldName = 'name';
  static const String _emailFieldName = 'email';
  static const String _organisationIdFieldName = 'organisationId';

  final DataService _data;

  OrganisationServices(this._data);

  Future<CreateOrganisationResponse> createOrganisation(CreateOrganisationRequest request) async {
    var c = Completer<CreateOrganisationResponse>();
    try {
      if (request.userId.isEmpty || request.organisationName.isEmpty) {
        throw (OrganisationServicesException('Invalid request - ${request.userId} - ${request.organisationName}'));
      }

      var l = await _data.query(_organisationCollectionName, field: _nameFieldName, value: request.organisationName);
      if (l.isNotEmpty) {
        throw (OrganisationServicesException('Organisation Name is already in use - ${request.organisationName}'));
      }

      var org = <String, dynamic>{};
      org[_nameFieldName] = request.organisationName;
      var id = await _data.set(_organisationCollectionName, org);

      _linkUserToOrganisation(request.userId, id);

      c.complete(CreateOrganisationResponse(true, organisationId: org[idFieldName]));
    } catch (ex) {
      c.completeError(ex);
    }

    return c.future;
  }

  Future<CheckOrganisationInvitationResponse> checkOrganisationInvitation(
      CheckOrganisationInvitationRequest request) async {
    var c = Completer<CheckOrganisationInvitationResponse>();

    try {
      if (request.email.isEmpty) {
        throw (OrganisationServicesException('Invalid request - email is empty'));
      }


      var l = await _data.query(_organisationInvitationCollectionName, field: _emailFieldName, value: request.email);
      if (l.isEmpty) {
        c.complete(CheckOrganisationInvitationResponse());
      } else {
        c.complete(CheckOrganisationInvitationResponse(
            organisationId: l.first[_organisationIdFieldName], organisationName: l.first[_nameFieldName]));
      }
    } catch (ex) {
      c.completeError(ex);
    }

    return c.future;
  }

  Future<AcceptOrganisationInvitationResponse> acceptOrganisationInvitation(
      AcceptOrganisationInvitationRequest request) async {
    var c = Completer<AcceptOrganisationInvitationResponse>();

    try {

      if (request.email.isEmpty || request.userId.isEmpty || request.organisationId.isEmpty) {
        throw (OrganisationServicesException('Invalid request - ${request.email} - ${request.userId} - ${request.organisationId}'));
      }

      var l = await _data.query(_organisationInvitationCollectionName, field: _emailFieldName, value: request.email);

      if (l.isEmpty) {
        throw OrganisationServicesException(
            'email address ${request.email} is not invited to any organisation');
      }

      await _linkUserToOrganisation(request.userId, request.organisationId);

      await _data.delete(_organisationInvitationCollectionName, l.first[idFieldName]);

      c.complete(AcceptOrganisationInvitationResponse(true));
    } catch (ex) {
      c.completeError(ex);
    }

    return c.future;
  }

  Future<CreateOrganisationInvitationResponse> createOrganisationInvitation(
      CreateOrganisationInvitationRequest request) async {
    var c = Completer<CreateOrganisationInvitationResponse>();

    try {
      if (request.email.isEmpty || request.organisationId.isEmpty || request.organisationName.isEmpty) {
        throw OrganisationServicesException(
            'invalid parameters ${request.email} - ${request.organisationId} - ${request.organisationName}');
      }

      var l = await _data.query(_organisationInvitationCollectionName, field: _emailFieldName, value: request.email);

      if (l.isNotEmpty) {
        throw OrganisationServicesException(
            'email address ${request.email} is already invited to another organisation');
      }

      var m = <String, dynamic>{};
      m[_emailFieldName] = request.email;
      m[_organisationIdFieldName] = request.organisationId;
      m[_nameFieldName] = request.organisationName;

      await _data.set(_organisationInvitationCollectionName, m);

      c.complete(CreateOrganisationInvitationResponse(true));
    } catch (ex) {
      c.completeError(ex);
    }

    return c.future;
  }

  Future<GetOrganisationResponse> getOrganisation(GetOrganisationRequest request) async {
    var c = Completer<GetOrganisationResponse>();
    try {
      if (request.userId.isEmpty) {
        throw (OrganisationServicesException('Invalid request - userId is empty '));
      }

      var l = await _data.query(_organisationUserCollectionName, field: userIdFieldName, value: request.userId);
      if (l.isEmpty) {
        throw (OrganisationServicesException('Invalid request - userId is not linked to an organisation '));
      }

      var m = await _data.get(_organisationCollectionName, l.first[_organisationIdFieldName]);

      c.complete(GetOrganisationResponse(true, organisationId: m[idFieldName], organisationName: m[_nameFieldName]));

      return c.future;
    } catch (ex) {
      c.completeError(ex);
    }

    return c.future;
  }

  Future<void> _linkUserToOrganisation(String userId, String organisationId) async {
    var c = Completer<void>();

    var link = <String, dynamic>{};
    link[userIdFieldName] = userId;
    link[_organisationIdFieldName] = organisationId;
    await _data.set(_organisationUserCollectionName, link);
    c.complete();
    return c.future;
  }
}

abstract class OrganisationServiceResponse {
  final bool valid;
  final String message;
  final String reference;

  OrganisationServiceResponse(this.valid, {this.message = '', this.reference = ''});
}

class CreateOrganisationRequest {
  final String userId;
  final String organisationName;
  CreateOrganisationRequest(this.organisationName, this.userId);
}

class CreateOrganisationResponse extends OrganisationServiceResponse {
  final String organisationId;

  CreateOrganisationResponse(bool valid, {this.organisationId = '', String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class CheckOrganisationInvitationRequest {
  final String email;

  CheckOrganisationInvitationRequest(this.email);
}

class CheckOrganisationInvitationResponse {
  bool get invitationFound => organisationId.isNotEmpty;
  final String organisationId;
  final String organisationName;

  CheckOrganisationInvitationResponse({this.organisationId = '', this.organisationName = ''});
}

class AcceptOrganisationInvitationRequest {
  final String userId;
  final String email;
  final String organisationId;

  AcceptOrganisationInvitationRequest(this.userId, this.email, this.organisationId);
}

class AcceptOrganisationInvitationResponse extends OrganisationServiceResponse {
  AcceptOrganisationInvitationResponse(bool valid, {String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class CreateOrganisationInvitationRequest {
  final String email;
  final String organisationId;
  final String organisationName;

  CreateOrganisationInvitationRequest(this.email, this.organisationId, this.organisationName);
}

class CreateOrganisationInvitationResponse extends OrganisationServiceResponse {
  CreateOrganisationInvitationResponse(bool valid, {String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class GetOrganisationRequest {
  final String userId;

  GetOrganisationRequest(this.userId);
}

class GetOrganisationResponse extends OrganisationServiceResponse {
  final String organisationId;
  final String organisationName;

  GetOrganisationResponse(bool valid,
      {this.organisationId = '', this.organisationName = '', String message = '', String reference = ''})
      : super(valid, message: message, reference: reference);
}

class OrganisationServicesException implements Exception {
  final String _message;

  OrganisationServicesException(this._message);

  @override
  String toString() => _message;
}
