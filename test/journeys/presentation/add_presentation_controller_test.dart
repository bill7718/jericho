import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/organisation/invite_to_organisation_controller.dart';
import 'package:jericho/journeys/organisation/invite_to_organisation_page.dart';
import 'package:jericho/journeys/presentation/add_presentation_controller.dart';
import 'package:jericho/journeys/presentation/presentation.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/presentation_services.dart';

import '../../mocks/mocks.dart';
import '../../mocks/services/mock_organisation_services.dart';
import '../../mocks/services/mock_presentation_services.dart';

void main() {
  MockUserNavigator navigator = MockUserNavigator();
  MockPresentationServices services = MockPresentationServices();
  SessionState session = SessionState();

  AddPresentationController controller = AddPresentationController(navigator, services, session);
  var context = '';

  setUp(() {
    navigator = MockUserNavigator();
    services = MockPresentationServices();
    session = SessionState();
    context = 'hello';
    controller = AddPresentationController(navigator, services, session);
    session.organisationId = MockOrganisationServices.invitedOrganisationId;
    session.organisationName = MockOrganisationServices.invitedOrganisationName;
  });

  group('Test Add Presentation Controller ', () {
    group('Start of journey', () {
      testWidgets('When the system initiates the journey  the system shows the Record Presentation page ',
          (WidgetTester tester) async {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
        expect(navigator.currentRoute, AddPresentationController.recordPresentationRoute);
        expect(navigator.level, 1);
      });
    });


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

  });
}
