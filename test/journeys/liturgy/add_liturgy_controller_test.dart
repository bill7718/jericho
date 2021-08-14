import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/liturgy/liturgy.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/liturgy_services.dart';

import '../../mocks/mocks.dart';
import '../../mocks/services/mock_liturgy_services.dart';

void main() {

  var orgId = 'org1';

  MockUserNavigator navigator = MockUserNavigator();
  MockLiturgyServices services = MockLiturgyServices();
  SessionState session = SessionState();

  AddLiturgyController controller = AddLiturgyController(navigator, services, session);
  var context = '';

  setUp(() {
    navigator = MockUserNavigator();
    services = MockLiturgyServices();
    session = SessionState();
    context = 'hello';
    controller = AddLiturgyController(navigator, services, session);
    session.organisationId = orgId;
  });

  group('Test Add Liturgy Controller', () {
    group('Start of journey', () {
      testWidgets('When the system initiates the journey the system shows the Record Liturgy Name page ',
          (WidgetTester tester) async {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
        expect(navigator.currentRoute, AddLiturgyController.recordLiturgyNameRoute);
        expect(navigator.currentInput is RecordLiturgyNameStateInput, true);
        var i = navigator.currentInput as RecordLiturgyNameStateInput;
        expect(i.name.isEmpty, true);
        expect(i.messageReference.isEmpty, true);
        expect(navigator.level, 1);
      });
    });

    group('Test Record Name', () {
      setUp(() async {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
      });

      testWidgets('When the user selects back from the Record Name page I expect the journey to be terminated ',
          (WidgetTester tester) async {
        await controller.handleEvent(context, event: UserJourneyController.backEvent);
        expect(navigator.level, 0);
      });

      testWidgets(
          'When the user selects next from the Record Name page with a new name I expect the system to go to the record content page ',
          (WidgetTester tester) async {
        var output = RecordLiturgyNameDynamicState('Hello');
        await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: output);
        expect(navigator.currentRoute, AddLiturgyController.recordLiturgyContentRoute);
        expect(navigator.currentInput is RecordLiturgyContentStateInput, true);
        var i = navigator.currentInput as RecordLiturgyContentStateInput;
        expect(i.name, 'Hello');
        expect(i.messageReference.isEmpty, true);
        expect(i.content.isEmpty, true);
      });

      testWidgets(
          'When the user selects next from the Record Name page with  an existing name I expect the system to stay on the record name page with an error ',
              (WidgetTester tester) async {
            var output = RecordLiturgyNameDynamicState(MockLiturgyServices.existingLiturgyName);
            await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: output);
            expect(navigator.currentRoute, AddLiturgyController.recordLiturgyNameRoute);
            expect(navigator.currentInput is RecordLiturgyNameStateInput, true);
            var i = navigator.currentInput as RecordLiturgyNameStateInput;
            expect(i.name, MockLiturgyServices.existingLiturgyName);
            expect(i.messageReference, AddLiturgyController.duplicateLiturgy);
          });
    });

    group('Test Record Content', ()
    {
      setUp(() async {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
        var output = RecordLiturgyNameDynamicState('Hello');
        await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: output);
      });

      testWidgets('When the user selects back from the Record Content page I expect to return to the name page ',
              (WidgetTester tester) async {
            await controller.handleEvent(context, event: UserJourneyController.backEvent);
            expect(navigator.currentRoute, AddLiturgyController.recordLiturgyNameRoute);
            expect(navigator.currentInput is RecordLiturgyNameStateInput, true);
            var i = navigator.currentInput as RecordLiturgyNameStateInput;
            expect(i.name, 'Hello');
          });

      testWidgets('When the user selects cancel from the Record Content page I expect the journey to be terminated ',
              (WidgetTester tester) async {
                await controller.handleEvent(context, event: UserJourneyController.cancelEvent);
                expect(navigator.level, 0);
          });

      testWidgets('When the user selects next from the Record Content page I expect the system to go to the preview liturgy page ',
              (WidgetTester tester) async {
        var output = RecordLiturgyContentDynamicState(content: 'Some new content');
            await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: output);
            expect(navigator.currentRoute, AddLiturgyController.previewLiturgyRoute);
            expect(navigator.currentInput is PreviewLiturgyStateInput, true, reason: navigator.currentInput.runtimeType.toString());
            var i = navigator.currentInput as PreviewLiturgyStateInput;
            expect(i.name, 'Hello');
            expect(i.content, 'Some new content');
            expect(i.messageReference.isEmpty, true);
          });
    });

    group('Test Preview Liturgy', ()
    {
      setUp(() async {
        await controller.handleEvent(context, event: UserJourneyController.initialEvent);
        var output = RecordLiturgyNameDynamicState('Hello');
        await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: output);
        var output2 = RecordLiturgyContentDynamicState(content: 'Some Content');
        await controller.handleEvent(context, event: UserJourneyController.nextEvent, output: output2);
        services.requests.clear();
      });

      testWidgets('When the user selects back from the Preview  page I expect to return to the contents page ',
              (WidgetTester tester) async {
            await controller.handleEvent(context, event: UserJourneyController.backEvent);
            expect(navigator.currentRoute, AddLiturgyController.recordLiturgyContentRoute);
            expect(navigator.currentInput is RecordLiturgyContentStateInput, true);
            var i = navigator.currentInput as RecordLiturgyContentStateInput;
            expect(i.name, 'Hello');
          });

      testWidgets('When the user selects cancel from the Preview page I expect the journey to be terminated ',
              (WidgetTester tester) async {
            await controller.handleEvent(context, event: UserJourneyController.cancelEvent);
            expect(navigator.level, 0);
          });

      testWidgets('When the user selects confirm from the Record Content page I expect the system to Create the Liturgy Item and terminate the journey ',
              (WidgetTester tester) async {

            await controller.handleEvent(context, event: UserJourneyController.confirmEvent);
            expect(navigator.level, 0);
            expect(navigator.currentInput is PreviewLiturgyStateInput, true, reason: navigator.currentInput.runtimeType.toString());
            expect(services.requests.length, 1);
            expect(services.requests.first is CreateLiturgyRequest, true);
            var request = services.requests.first as CreateLiturgyRequest;
            expect(request.name, 'Hello');
            expect(request.text, 'Some Content');
            expect(request.organisationId, orgId);

          });
    });
  });
}
