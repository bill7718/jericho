

import 'dart:async';

import 'package:jericho/services/organisation_services.dart';

class MockOrganisationServices implements OrganisationServices {

  static const String invitedEmail = 'invited@b.com';
  static const String invitedUserId = 'invite';
  static const String invitedOrganisationId = 'invitedOrg';
  static const String invitedOrganisationName = 'All Welcome';

  List<String> serviceCalls = <String>[];

  String? email;
  String? userId;
  String? organisationId;
  String? organisationName;

  @override
  Future<AcceptOrganisationInvitationResponse> acceptOrganisationInvitation(AcceptOrganisationInvitationRequest request) {
    var c = Completer<AcceptOrganisationInvitationResponse>();

    email = request.email;
    userId = request.userId;
    organisationId = request.organisationId;


    serviceCalls.add('acceptOrganisationInvitation');
    c.complete(AcceptOrganisationInvitationResponse(true));
    return c.future;
  }

  @override
  Future<CheckOrganisationInvitationResponse> checkOrganisationInvitation(CheckOrganisationInvitationRequest request) {
    var c = Completer<CheckOrganisationInvitationResponse>();

    if (request.email == invitedEmail) {
      c.complete(CheckOrganisationInvitationResponse(organisationId: invitedOrganisationId, organisationName: invitedOrganisationName));
    } else {
      c.complete(CheckOrganisationInvitationResponse());
    }
    serviceCalls.add('checkOrganisationInvitation');
    return c.future;
  }

  @override
  Future<CreateOrganisationResponse> createOrganisation(CreateOrganisationRequest request) {
    var c = Completer<CreateOrganisationResponse>();

    userId = request.userId;
    organisationName = request.organisationName;

    serviceCalls.add('createOrganisation');
    c.complete(CreateOrganisationResponse(true, organisationId: '${organisationName}id'));
    return c.future;
  }

  @override
  Future<CreateOrganisationInvitationResponse> createOrganisationInvitation(CreateOrganisationInvitationRequest request) {
    var c = Completer<CreateOrganisationInvitationResponse>();
    email = request.email;
    organisationId = request.organisationId;
    organisationName = request.organisationName;
    serviceCalls.add('createOrganisationInvitation');
    c.complete(CreateOrganisationInvitationResponse(true));
    return c.future;

  }

  @override
  Future<GetOrganisationResponse> getOrganisation(GetOrganisationRequest request) {
    // TODO: implement getOrganisation
    throw UnimplementedError();
  }


}