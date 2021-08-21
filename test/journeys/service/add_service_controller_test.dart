
import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/service/add_service_controller.dart';
import 'package:jericho/journeys/service/record_service_name_page.dart';
import 'package:jericho/journeys/service/record_service_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/service_services.dart';

import '../../mocks/mocks.dart';
import '../../mocks/services/mock_organisation_services.dart';
import '../../mocks/services/mock_service_services.dart';

void main() {
  MockUserNavigator navigator = MockUserNavigator();
  MockServiceServices services = MockServiceServices();
  SessionState session = SessionState();

  AddServiceController controller = AddServiceController(navigator, services, session);
  var context = '';

  setUp(() {
    navigator = MockUserNavigator();
    services = MockServiceServices();
    session = SessionState();
    context = 'hello';
    controller = AddServiceController(navigator, services, session);
    session.organisationId = MockOrganisationServices.invitedOrganisationId;
    session.organisationName = MockOrganisationServices.invitedOrganisationName;
  });

  group('Test AddServiceController', () {
    group('Start of journey', () {
      testWidgets('When the system initiates the journey the system shows the RecordService Name page',
          (WidgetTester tester) async {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
        expect(navigator.currentRoute, AddServiceController.recordServiceNameRoute);
        expect(navigator.level, 1);
      });
    });

    group('Current route is RecordServiceName', () {
      setUp(() async {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      });

      testWidgets(
          'When the system handles a Next Event with a new service name then the system shows the RecordService page with the service items',
          (WidgetTester tester) async {
        var serviceName = 'newName';
        await controller.handleEvent(context,
            event: UserJourneyController.nextEvent, output: RecordServiceNameDynamicState(serviceName));

        expect(services.requests.first is CheckServiceRequest, true);
        expect(services.requests.last is GetAllServiceItemsRequest, true);

        expect(navigator.currentRoute, AddServiceController.recordServiceRoute);
        expect(navigator.level, 1);
        var i = navigator.currentInput as RecordServiceStateInput;
        expect(i.name, serviceName);
        expect(i.serviceItems.length, 1);
      });

      testWidgets(
          'When the system handles a Next Event with an existing service name then the system shows the RecordServiceName page with an error',
          (WidgetTester tester) async {
        await controller.handleEvent(context,
            event: UserJourneyController.nextEvent, output: RecordServiceNameDynamicState(MockServiceServices.existingService));

        expect(services.requests.first is CheckServiceRequest, true);
        expect(services.requests.length, 1);


        expect(navigator.currentRoute, AddServiceController.recordServiceNameRoute);
        expect(navigator.level, 1);
        var i = navigator.currentInput as RecordServiceNameStateInput;
        expect(i.name, MockServiceServices.existingService);
      });

      testWidgets('When the user selects back the system quits the journey', (WidgetTester tester) async {
        await controller.handleEvent(context, event: UserJourneyController.backEvent);
        expect(navigator.level, 0);
        expect(services.requests.isEmpty, true);

      });
    });

    group('Current route is RecordService', ()
    {
      var serviceName = 'newName';
      setUp(() async {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
        await controller.handleEvent(context,
            event: UserJourneyController.nextEvent, output: RecordServiceNameDynamicState(serviceName));
      });

      testWidgets('When the user selects next the the system goes to the preview page', (WidgetTester tester) async {
        await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: RecordServiceDynamicState(fullServiceContents: MockServiceServices.serviceItems));
        expect(navigator.level, 1);
        expect(navigator.currentRoute, AddServiceController.previewServiceRoute);
      });

      testWidgets('When the user selects next the system goes back to the name page', (WidgetTester tester) async {
        await controller.handleEvent(context, event: UserJourneyController.backEvent);
        expect(navigator.level, 1);
        expect(navigator.currentRoute, AddServiceController.recordServiceNameRoute);
      });


    });

    group('Current route is PreviewService', ()
    {
      var serviceName = 'newName';
      setUp(() async {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
        await controller.handleEvent(context,
            event: UserJourneyController.nextEvent, output: RecordServiceNameDynamicState(serviceName));
        await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: RecordServiceDynamicState(fullServiceContents: MockServiceServices.serviceItems));
      });

      testWidgets('When the user selects next the the system creates the service and quites the journey', (WidgetTester tester) async {
        await controller.handleEvent(context, event: UserJourneyController.nextEvent);
        expect(navigator.level, 0);
        var request = services.requests.last as CreateServiceRequest;
        expect(request.name, serviceName);
        expect(request.organisationId, session.organisationId);
        expect(request.serviceElements.first.id, MockServiceServices.serviceItems.first.id);

      });

      testWidgets('When the user selects next the system goes back to the name page', (WidgetTester tester) async {
        await controller.handleEvent(context, event: UserJourneyController.backEvent);
        expect(navigator.level, 1);
        expect(navigator.currentRoute, AddServiceController.recordServiceRoute);
      });


    });

    /*
    group('Current route is Record Presentation', () {
      setUp(() async {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      });

      testWidgets(
          'When the system receives a next event in Invite User then the system creates the user invitation and returns to the landing page ',
          (WidgetTester tester) async {
            var output = RecordPresentationDynamicState('NewPres', );
            output.fileName = 'newfile.pdf';
            output.data = Uint8List.fromList([1,2,3,4]);
        await controller.handleEvent(context,
            event: UserJourneyController.nextEvent, output: output);
        expect(navigator.level, 0);

        expect(services.requests.length, 2);
        var r1 = services.requests.first as CheckPresentationRequest;
        expect(r1.name, 'NewPres');
        expect(r1.organisationId, MockOrganisationServices.invitedOrganisationId);

        var r2 = services.requests.last as CreatePresentationRequest;
        expect(r2.name, r1.name);
        expect(r2.organisationId, r1.organisationId);
        expect(r2.data.length, output.data.length);


      });

      testWidgets(
          'When the system receives a next event in Invite User then the system creates the user invitation and returns to the landing page ',
              (WidgetTester tester) async {
            var output = RecordPresentationDynamicState(MockPresentationServices.existingName, );
            output.fileName = 'newfile.pdf';
            output.data = Uint8List.fromList([1,2,3,4]);
            await controller.handleEvent(context,
                event: UserJourneyController.nextEvent, output: output);
            expect(navigator.level, 1);
            expect(navigator.currentRoute, AddPresentationController.recordPresentationRoute);
            expect(services.requests.length, 1);
            var r1 = services.requests.first as CheckPresentationRequest;
            expect(r1.name, MockPresentationServices.existingName);
            expect(r1.organisationId, MockOrganisationServices.invitedOrganisationId);

            expect(navigator.currentInput is RecordPresentationStateInput, true);
            expect((navigator.currentInput as RecordPresentationStateInput).messageReference, AddPresentationController.duplicatePresentation);


          });


      testWidgets('When the user selects back the system goes to the welcome page', (WidgetTester tester) async {
        await controller.handleEvent(context, event: UserJourneyController.backEvent);
        expect(navigator.level, 0);
        expect(services.requests.isEmpty, true);
      });

    });

     */
  });
}
