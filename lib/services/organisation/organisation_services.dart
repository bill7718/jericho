import 'dart:async';

import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/services/firebase_service.dart';
import 'package:jericho/services/key_generator.dart';

class OrganisationServices {
  static const String _organisationCollectionName = 'Organisation';
  static const String _organisationUserCollectionName = 'OrganisationUser';
  static const String _organisationInvitationCollectionName = 'OrganisationInvitation';

  static const String _nameFieldName = 'name';
  static const String _emailFieldName = 'email';
  static const String _organisationIdFieldName = 'organisationId';

  final FirebaseService _fb;
  final KeyGenerator _gen;

  OrganisationServices(this._fb, this._gen);

  Future<CreateOrganisationResponse> createOrganisation(CreateOrganisationRequest request) async {
    var c = Completer<CreateOrganisationResponse>();
    try {
      if (request.userId.isEmpty || request.organisationName.isEmpty) {
        throw (OrganisationServicesException('Invalid request - ${request.userId} - ${request.organisationName}'));
      }

      var l = await _fb.query(_organisationCollectionName, field: _nameFieldName, value: request.organisationName);
      if (l.isNotEmpty) {
        c.complete(CreateOrganisationResponse(false,
            message: 'Organisation Name is already in use', reference: 'duplicateOrganisation'));
        return c.future;
      }

      var org = <String, dynamic>{};
      org[_nameFieldName] = request.organisationName;
      org[idFieldName] = _gen.getKey();
      await _fb.set(_organisationCollectionName + '/' + org[idFieldName], org);

      _linkUserToOrganisation(request.userId, org[idFieldName]);
    } catch (ex) {
      c.completeError(ex);
    }

    return c.future;
  }

  Future<CheckOrganisationInvitationResponse> checkOrganisationInvitation(
      CheckOrganisationInvitationRequest request) async {
    var c = Completer<CheckOrganisationInvitationResponse>();

    try {
      var l = await _fb.query(_organisationInvitationCollectionName, field: _emailFieldName, value: request.email);
      if (l.isEmpty) {
        c.complete(CheckOrganisationInvitationResponse());
      } else {
        if (l.length == 1) {
          c.complete(CheckOrganisationInvitationResponse(
              organisationId: l.first[_organisationIdFieldName], organisationName: l.first[_nameFieldName]));
        } else {
          throw OrganisationServicesException(
              'email address ${request.email} is invited to more than one organisation');
        }
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
      var l = await _fb.query(_organisationInvitationCollectionName, field: _emailFieldName, value: request.email);

      if (l.isEmpty || l.length > 1) {
        throw OrganisationServicesException(
            'email address ${request.email} is invited to either zero or more than one organisation');
      }

      await _linkUserToOrganisation(request.userId, request.organisationId);

      await _fb.delete('$_organisationInvitationCollectionName/${l.first[idFieldName]}');

      c.complete(AcceptOrganisationInvitationResponse(true));


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
    link[idFieldName] = _gen.getKey();
    await _fb.set(_organisationUserCollectionName + '/' + link[idFieldName], link);
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

class OrganisationServicesException implements Exception {
  final String _message;

  OrganisationServicesException(this._message);

  @override
  String toString() => _message;
}
