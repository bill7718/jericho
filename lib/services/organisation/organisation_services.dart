


import 'dart:async';

import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/services/firebase_service.dart';
import 'package:jericho/services/key_generator.dart';

class OrganisationServices {
  static const String _organisationCollectionName = 'Organisation';
  static const String _organisationUserCollectionName = 'OrganisationUser';

  static const String _nameFieldName = 'name';
  static const String _organisationIdFieldName = 'organisationId';


  final FirebaseService _fb;
  final KeyGenerator _gen;

  OrganisationServices(this._fb, this._gen);



  Future<CreateOrganisationResponse> createUser(CreateOrganisationRequest request) async {
    var c = Completer<CreateOrganisationResponse>();
    try {

      if (request.userId.isEmpty || request.organisationName.isEmpty) {
        throw (OrganisationServicesException('Invalid request - ${request.userId} - ${request.organisationName}'));
      }

      var l = await _fb.query(_organisationCollectionName, field: _nameFieldName, value: request.organisationName);
      if (l.isNotEmpty) {
        c.complete(CreateOrganisationResponse(false, message: 'Organisation Name is already in use', reference: 'duplicateOrganisation'));
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

  OrganisationServiceResponse(this.valid,  { this.message = '', this.reference = '' });
}

abstract class CreateOrganisationRequest {

  String get userId;
  String get organisationName;

}

class CreateOrganisationResponse extends OrganisationServiceResponse {

  final String organisationId;

  CreateOrganisationResponse(bool valid,  { this.organisationId = '', String message = '', String reference = '' } ) : super(valid, message: message, reference: reference);

}

class OrganisationServicesException implements Exception {
  final String _message;

  OrganisationServicesException(this._message);

  @override
  String toString() => _message;
}