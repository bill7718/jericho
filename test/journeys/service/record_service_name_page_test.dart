import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/service/record_service_name_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/service_services.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();
  });

  group('Test RecordServiceNamePage', () {
    testWidgets('When the system initiates RecordServiceNamePage the correct widgets are shown',
        (WidgetTester tester) async {
      MockPage page = MockPage(RecordServiceNamePage(
        eventHandler: handler,
        inputState: MockRecordServiceNameStateInput(),
      ));
      await tester.pumpWidget(page);

      expect(findAppBarByTitle(page.getter.getPageTitle(RecordServiceNamePage.titleRef)), findsOneWidget);
      checkTextInputFields([page.getter.getLabel(RecordServiceNamePage.serviceNameLabel)]);
      checkButtons([page.getter.getButtonText(nextButton), page.getter.getButtonText(previousButton)]);

      // there is no error message
      checkFormError('');
    });

    testWidgets('When the system initiates RecordServiceNamePage with a name in the input state then this name is shown',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordServiceNamePage(
            eventHandler: handler,
            inputState: MockRecordServiceNameStateInput(name: 'Brian'),
          ));
          await tester.pumpWidget(page);

          checkTextInputFieldValue(page.getter.getLabel(RecordServiceNamePage.serviceNameLabel), 'Brian');
        });

    testWidgets('When the user clicks the previous button the system invokes the previous event',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordServiceNamePage(
            eventHandler: handler,
            inputState: MockRecordServiceNameStateInput(),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(previousButton), tester);
          expect(handler.lastEvent, UserJourneyController.backEvent);
        });

    testWidgets(
        'When the user clicks the next button without any data input the system does not invoke an event and error messages are shown',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordServiceNamePage(
            eventHandler: handler,
            inputState: MockRecordServiceNameStateInput(),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, '');
          expect(find.text(page.getter.getErrorMessage(ServiceValidator.nameError)), findsOneWidget);
        });

    testWidgets('When the user clicks the next button with valid input the next event is sent with the correct data',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordServiceNamePage(
            eventHandler: handler,
            inputState: MockRecordServiceNameStateInput(),
          ));
          await tester.pumpWidget(page);
          await enterText(tester, page.getter.getLabel(RecordServiceNamePage.serviceNameLabel), 'Bill');
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, UserJourneyController.nextEvent);
          var output = handler.lastOutput as RecordServiceNameStateOutput;
          expect(output.name, 'Bill');
        });
  });
}

class MockRecordServiceNameStateInput implements RecordServiceNameStateInput {


  MockRecordServiceNameStateInput({this.name = '', this.messageReference = ''});

  @override
  final String messageReference;

  @override
  final String name;
}
