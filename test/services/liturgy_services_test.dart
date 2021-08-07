import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/services/data_service.dart';
import 'package:jericho/services/key_generator.dart';
import 'package:jericho/services/mock_firebase_service.dart';

import 'package:jericho/services/liturgy_services.dart';

void main() {
  DataService db = DataService(MockFirebaseService(), KeyGenerator());

  LiturgyServices services = LiturgyServices(db);

  group('Create Liturgy', () {
    setUp(() {
      db = DataService(MockFirebaseService(), KeyGenerator());
      services = LiturgyServices(db);
    });

    testWidgets(
        'When the Create Liturgy service is called with valid data the system creates the Liturgy and it can be retrieved ',
        (WidgetTester tester) async {
      var request = CreateLiturgyRequest('orgId', 'My liturgy', 'liturgy content');
      try {
        var response = await services.createLiturgy(request);
        expect(response.id.isEmpty, false);
        expect(response.valid, true);

        var getResponse = await services.getLiturgy(GetLiturgyRequest(id: response.id));
        expect(getResponse.name, request.name);
        expect(getResponse.text, request.text);
        getResponse= await services.getLiturgy(GetLiturgyRequest(organisationId: request.organisationId, name: request.name));
        expect(getResponse.name, request.name);
        expect(getResponse.text, request.text);
      } catch (ex) {
        expect(ex is LiturgyServicesException, true, reason: ex.toString());
        expect(true, false);
      }
    });

    testWidgets('When the Create Liturgy service is called with an empty organisation id I expect an Exception ',
        (WidgetTester tester) async {
      var request = CreateLiturgyRequest('', 'My liturgy', 'liturgy content');
      try {
        await services.createLiturgy(request);
        expect(true, false);
      } catch (ex) {
        expect(ex is LiturgyServicesException, true, reason: ex.toString());
      }
    });

    testWidgets('When the Create Liturgy service is called with an empty name I expect an Exception ',
        (WidgetTester tester) async {
      var request = CreateLiturgyRequest('orgId', '', 'liturgy content');
      try {
        await services.createLiturgy(request);
        expect(true, false);
      } catch (ex) {
        expect(ex is LiturgyServicesException, true, reason: ex.toString());
      }
    });

    testWidgets('When the Create Liturgy service is called with an empty text I expect an Exception ',
        (WidgetTester tester) async {
      var request = CreateLiturgyRequest('orgId', 'My liturgy', '');
      try {
        await services.createLiturgy(request);
        expect(true, false);
      } catch (ex) {
        expect(ex is LiturgyServicesException, true, reason: ex.toString());
      }
    });

    testWidgets('When the Create Liturgy service is called with duplicate data I expect an Exception ',
        (WidgetTester tester) async {
      var request = CreateLiturgyRequest('orgId', 'My liturgy', 'liturgy content');
      try {
        await services.createLiturgy(request);
        await services.createLiturgy(request);
        expect(true, false);
      } catch (ex) {
        expect(ex is LiturgyServicesException, true, reason: ex.toString());
      }
    });

    testWidgets(
        'When the Create Liturgy service is called with duplicate data except for organisation Id the system creates the Liturgy and it can be retrieved  ',
        (WidgetTester tester) async {
      var request = CreateLiturgyRequest('orgId', 'My liturgy', 'liturgy content');
      try {
        var response = await services.createLiturgy(request);
        request = CreateLiturgyRequest('orgId2', 'My liturgy', 'liturgy content');
        response = await services.createLiturgy(request);
        expect(response.id.isEmpty, false);
        expect(response.valid, true);

        var getResponse = await services.getLiturgy(GetLiturgyRequest(id: response.id));
        expect(getResponse.name, request.name);
        expect(getResponse.text, request.text);
      } catch (ex) {
        expect(ex is LiturgyServicesException, true, reason: ex.toString());
        expect(true, false);
      }
    });
  });

  group('Get Liturgy', ()
  {
    setUp(() {
      db = DataService(MockFirebaseService(), KeyGenerator());
      services = LiturgyServices(db);
    });

    testWidgets(
        'When the GetLiturgy service is called with data present using the id of the liturgy then I expect it to be found ',
            (WidgetTester tester) async {
          var request = CreateLiturgyRequest('orgId', 'My liturgy', 'liturgy content');
          try {
            var response = await services.createLiturgy(request);
            var getResponse = await services.getLiturgy(GetLiturgyRequest(id: response.id));
            expect(getResponse.name, request.name);
            expect(getResponse.text, request.text);
          } catch (ex) {
            expect(ex is LiturgyServicesException, true, reason: ex.toString());
            expect(true, false);
          }
        });

    testWidgets(
        'When the GetLiturgy service is called with data present using the organisation Id and the name of the liturgy then I expect it to be found ',
            (WidgetTester tester) async {
          var request = CreateLiturgyRequest('orgId', 'My liturgy', 'liturgy content');
          try {
            await services.createLiturgy(request);
            var getResponse = await services.getLiturgy(GetLiturgyRequest(organisationId: request.organisationId, name: request.name));
            expect(getResponse.name, request.name);
            expect(getResponse.text, request.text);
          } catch (ex) {
            expect(ex is LiturgyServicesException, true, reason: ex.toString());
            expect(true, false);
          }
        });

    testWidgets(
        'When the GetLiturgy service is called with data not present using the organisation Id and the name of the liturgy then I expect it to be found ',
            (WidgetTester tester) async {
          var request = CreateLiturgyRequest('orgId', 'My liturgy', 'liturgy content');
          try {
            await services.createLiturgy(request);
            var getResponse = await services.getLiturgy(GetLiturgyRequest(organisationId: 'orgId2', name: 'name2'));
            expect(getResponse.valid, false);
          } catch (ex) {
            expect(ex is LiturgyServicesException, true, reason: ex.toString());
            expect(true, false);
          }
        });

    testWidgets(
        'When the GetLiturgy service is called with data not present using matching organisation Id and not matching  name of the liturgy then I expect it to be found ',
            (WidgetTester tester) async {
          var request = CreateLiturgyRequest('orgId', 'My liturgy', 'liturgy content');
          try {
            await services.createLiturgy(request);
            var getResponse = await services.getLiturgy(GetLiturgyRequest(organisationId: request.organisationId, name: 'name2'));
            expect(getResponse.valid, false);
          } catch (ex) {
            expect(ex is LiturgyServicesException, true, reason: ex.toString());
            expect(true, false);
          }
        });

    testWidgets(
        'When the GetLiturgy service is called with data not present using matching name and not matching  organisationId of the liturgy then I expect it to be found ',
            (WidgetTester tester) async {
          var request = CreateLiturgyRequest('orgId', 'My liturgy', 'liturgy content');
          try {
            await services.createLiturgy(request);
            var getResponse = await services.getLiturgy(GetLiturgyRequest(organisationId: 'org2', name: request.name));
            expect(getResponse.valid, false);
          } catch (ex) {
            expect(ex is LiturgyServicesException, true, reason: ex.toString());
            expect(true, false);
          }
        });

    testWidgets('When the GetLiturgy service is called with an empty id and organisationId I expect an exception ',
            (WidgetTester tester) async {
          try {
            await services.getLiturgy(GetLiturgyRequest(name: 'name2'));
            expect(true, false);
          } catch (ex) {
            expect(ex is LiturgyServicesException, true, reason: ex.toString());
          }
        });

    testWidgets('When the GetLiturgy service is called with an empty id and name I expect an exception ',
            (WidgetTester tester) async {
          try {
            await services.getLiturgy(GetLiturgyRequest(organisationId: 'orgId3'));
            expect(true, false);
          } catch (ex) {
            expect(ex is LiturgyServicesException, true, reason: ex.toString());
          }
        });
  });
}
