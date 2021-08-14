import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/liturgy/liturgy.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_name_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/liturgy_services.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();
  });

  group('Test Record Liturgy Name Page', () {
    testWidgets('When the system initiates Record Liturgy Name the correct widgets are shown',
        (WidgetTester tester) async {
      MockPage page = MockPage(RecordLiturgyNamePage(
        eventHandler: handler,
        inputState: MockRecordLiturgyNameStateInput(),
      ));
      await tester.pumpWidget(page);

      expect(findAppBarByTitle(page.getter.getPageTitle(RecordLiturgyNamePage.titleRef)), findsOneWidget);
      checkTextInputFields([page.getter.getLabel(RecordLiturgyNamePage.liturgyNameLabel)]);
      checkButtons([page.getter.getButtonText(nextButton), page.getter.getButtonText(previousButton)]);

      // there is no error message
      checkFormError('');
    });

    testWidgets('When the system initiates Record Liturgy Name with a name in the input state then this name is shown',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordLiturgyNamePage(
            eventHandler: handler,
            inputState: MockRecordLiturgyNameStateInput(name: 'Brian'),
          ));
          await tester.pumpWidget(page);

          checkTextInputFieldValue(page.getter.getLabel(RecordLiturgyNamePage.liturgyNameLabel), 'Brian');
        });

    testWidgets('When the user clicks the previous button the system invokes the previous event',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordLiturgyNamePage(
            eventHandler: handler,
            inputState: MockRecordLiturgyNameStateInput(),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(previousButton), tester);
          expect(handler.lastEvent, UserJourneyController.backEvent);
        });

    testWidgets(
        'When the user clicks the next button without any data input the system does not invoke an event and error messages are shown',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordLiturgyNamePage(
            eventHandler: handler,
            inputState: MockRecordLiturgyNameStateInput(),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, '');
          expect(find.text(page.getter.getErrorMessage(LiturgyValidator.nameError)), findsOneWidget);
        });

    testWidgets('When the user clicks the next button with valid input the next event is sent with the correct data',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordLiturgyNamePage(
            eventHandler: handler,
            inputState: MockRecordLiturgyNameStateInput(),
          ));
          await tester.pumpWidget(page);
          await enterText(tester, page.getter.getLabel(RecordLiturgyNamePage.liturgyNameLabel), 'Bill');
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, UserJourneyController.nextEvent);
          var output = handler.lastOutput as RecordLiturgyNameStateOutput;
          expect(output.name, 'Bill');
        });
  });
}

class MockRecordLiturgyNameStateInput implements RecordLiturgyNameStateInput {


  MockRecordLiturgyNameStateInput({this.name = '', this.messageReference = ''});

  @override
  final String messageReference;

  @override
  final String name;
}
