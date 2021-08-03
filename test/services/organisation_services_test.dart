import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/services/data_service.dart';
import 'package:jericho/services/key_generator.dart';
import 'package:jericho/services/mock_firebase_service.dart';

import 'package:jericho/services/organisation_services.dart';


void main() {
  DataService db = DataService(MockFirebaseService(), KeyGenerator());
  OrganisationServices services = OrganisationServices(db);

  group('Create Organisation', () {

    setUp(() {
      db = DataService(MockFirebaseService(), KeyGenerator());
      services = OrganisationServices(db);
    });

    testWidgets('When the Create Organisation service is called with valid data the system creates the Organisation and it can be retrieved ',
        (WidgetTester tester) async {
      var request = CreateOrganisationRequest('Org name', 'myId');
      try {
        var response = await services.createOrganisation(request);
        expect(response.organisationId.isEmpty, false);

        var getResponse = await services.getOrganisation(GetOrganisationRequest('myId'));
        expect(getResponse.organisationId, response.organisationId);
        expect(getResponse.organisationName, 'Org name');
      } catch (ex) {
        expect(ex is OrganisationServicesException, true, reason: ex.toString());
      }
    });

    testWidgets('When the Create Organisation service is called with an empty name the system throws an exception ',
            (WidgetTester tester) async {
          var request = CreateOrganisationRequest('', 'myId');
          try {
            await services.createOrganisation(request);
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets('When the Create Organisation service is called with an empty userId the system throws an exception ',
            (WidgetTester tester) async {
          var request = CreateOrganisationRequest('Org name', '');

          try {
            await services.createOrganisation(request);
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets('When the Create Organisation service is called with duplicate name the system throws an exception',
            (WidgetTester tester) async {
          var request = CreateOrganisationRequest('Org name', 'myid');
          var i = 0;
          try {
            await services.createOrganisation(request);
            i++;
            await services.createOrganisation(request);
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
            expect(i, 1);
          }
        });
  });

  group('Get Organisation', ()
  {
    setUp(() {
      db = DataService(MockFirebaseService(), KeyGenerator());
      services = OrganisationServices(db);
    });

    testWidgets(
        'When the Create Organisation service is called with valid data the system a Get hte organisation back ',
            (WidgetTester tester) async {
          var request = CreateOrganisationRequest('Org name', 'myId');
          try {
            var response = await services.createOrganisation(request);
            expect(response.organisationId.isEmpty, false);

            var getResponse = await services.getOrganisation(GetOrganisationRequest('myId'));
            expect(getResponse.organisationId, response.organisationId);
            expect(getResponse.organisationName, 'Org name');
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When the Get organisation service is called witha an empty userid the system throws an exception  ',
            (WidgetTester tester) async {
          try {

            await services.getOrganisation(GetOrganisationRequest(''));
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When there is no organisation for a user id the system throws an exception ',
            (WidgetTester tester) async {
          var request = CreateOrganisationRequest('Org name', 'myId');
          try {
            var response = await services.createOrganisation(request);
            expect(response.organisationId.isEmpty, false);

            var getResponse = await services.getOrganisation(GetOrganisationRequest('myId2'));
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });
  });

  group('Create Invitation', ()
  {
    setUp(() {
      db = DataService(MockFirebaseService(), KeyGenerator());
      services = OrganisationServices(db);
    });

    testWidgets(
        'When the Create Invitation service is called with valid data the data is retrieved from a call to the Check service  ',
            (WidgetTester tester) async {
          var request = CreateOrganisationInvitationRequest('a@b.com', 'orgId', 'Org Name');
          try {
            var response = await services.createOrganisationInvitation(request);
            expect(response.valid, true);

            var checkResponse = await services.checkOrganisationInvitation(CheckOrganisationInvitationRequest(request.email));
            expect(checkResponse.organisationId, request.organisationId);
            expect(checkResponse.organisationName, request.organisationName);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When the Create Invitation service is called with an empty email address I expect an exception   ',
            (WidgetTester tester) async {
          var request = CreateOrganisationInvitationRequest('', 'orgId', 'Org Name');
          try {
            await services.createOrganisationInvitation(request);
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When the Create Invitation service is called with an empty organisationId I expect an exception   ',
            (WidgetTester tester) async {
          var request = CreateOrganisationInvitationRequest('a@b.com', '', 'Org Name');
          try {
            await services.createOrganisationInvitation(request);
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When the Create Invitation service is called with an empty organisation NameI expect an exception   ',
            (WidgetTester tester) async {
          var request = CreateOrganisationInvitationRequest('a@b.com', 'orgId', '');
          try {
            await services.createOrganisationInvitation(request);
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When the Create Invitation service is called twice with valid data I expect an exception  ',
            (WidgetTester tester) async {
          var request = CreateOrganisationInvitationRequest('a@b.com', 'orgId', 'Org Name');
          var i = 0;
          try {
            var response = await services.createOrganisationInvitation(request);
            expect(response.valid, true);
            i++;
            response = await services.createOrganisationInvitation(request);


          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
            expect(i, 1);
          }
        });
  });

  group('Check Invitation', ()
  {
    setUp(() {
      db = DataService(MockFirebaseService(), KeyGenerator());
      services = OrganisationServices(db);
    });

    testWidgets(
        'When the Create Invitation service is called with valid data the data can be retrieved by a call to the Check Service  ',
            (WidgetTester tester) async {
          var request = CreateOrganisationInvitationRequest('a@b.com', 'orgId', 'Org Name');
          try {
            var response = await services.createOrganisationInvitation(request);
            expect(response.valid, true);

            var checkResponse = await services.checkOrganisationInvitation(
                CheckOrganisationInvitationRequest(request.email));
            expect(checkResponse.organisationId, request.organisationId);
            expect(checkResponse.organisationName, request.organisationName);
            expect(checkResponse.invitationFound, true);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When a valid call to the CheckService is made and the data is not present I expect a response to be not valid ',
            (WidgetTester tester) async {
          try {

            var checkResponse = await services.checkOrganisationInvitation(
                CheckOrganisationInvitationRequest('a@b.com'));
            expect(checkResponse.organisationId, '');
            expect(checkResponse.organisationName, '');
            expect(checkResponse.invitationFound, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When the Check Invitation service is called with an empty email address I expect an exception   ',
            (WidgetTester tester) async {

          try {
            await services.checkOrganisationInvitation(
              CheckOrganisationInvitationRequest(''));
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });
  });

  group('Accept Invitation', ()
  {
    setUp(() {
      db = DataService(MockFirebaseService(), KeyGenerator());
      services = OrganisationServices(db);
    });

    testWidgets(
        'When the Accept Invitation service is called with valid data the invitation can be accepted by the accept service  ',
            (WidgetTester tester) async {
          var request = CreateOrganisationInvitationRequest('a@b.com', 'orgId', 'Org Name');
          try {
            var response = await services.createOrganisationInvitation(request);
            expect(response.valid, true);

            var acceptResponse = await services.acceptOrganisationInvitation(
                AcceptOrganisationInvitationRequest('myId', request.email, 'OrgId'));

            expect(acceptResponse.valid, true);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When the Accept Invitation service is called twice with valid data the I expect an exception',
            (WidgetTester tester) async {
          var request = CreateOrganisationInvitationRequest('a@b.com', 'orgId', 'Org Name');
          var i = 0;
          try {
            await services.createOrganisationInvitation(request);

           await services.acceptOrganisationInvitation(
                AcceptOrganisationInvitationRequest('myId', request.email, 'OrgId'));
            i++;
            await services.acceptOrganisationInvitation(
                AcceptOrganisationInvitationRequest('myId', request.email, 'OrgId'));
            expect(true, false);

          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
            expect(i, 1);
          }
        });

    testWidgets(
        'When a valid call to the Accept Service is made and the data is not present I expect a response to be not valid ',
            (WidgetTester tester) async {
          try {

            await services.acceptOrganisationInvitation(
                AcceptOrganisationInvitationRequest('myId', 'a@b.com', 'OrgId'));
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When the Accept Invitation service is called with an empty email address I expect an exception   ',
            (WidgetTester tester) async {

          try {
            await services.acceptOrganisationInvitation(
                AcceptOrganisationInvitationRequest('myId', '', 'OrgId'));
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When the Accept Invitation service is called with an empty userId I expect an exception   ',
            (WidgetTester tester) async {

          try {
            await services.acceptOrganisationInvitation(
                AcceptOrganisationInvitationRequest('', 'a@b.com', 'OrgId'));
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });

    testWidgets(
        'When the Accept Invitation service is called with an empty organisationId I expect an exception   ',
            (WidgetTester tester) async {

          try {
            await services.acceptOrganisationInvitation(
                AcceptOrganisationInvitationRequest('myId', 'a@b.com', ''));
            expect(true, false);
          } catch (ex) {
            expect(ex is OrganisationServicesException, true, reason: ex.toString());
          }
        });
  });
}
