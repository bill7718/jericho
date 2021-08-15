import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/liturgy/liturgy.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_name_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/liturgy_services.dart';
import 'package:jericho/widgets/preview_content.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();
  });

  group('Test Preview Liturgy Page', () {
    testWidgets('When the system initiates Preview Liturgy the correct widgets are shown',
        (WidgetTester tester) async {
      MockPage page = MockPage(PreviewLiturgyPage(
        eventHandler: handler,
        inputState: MockPreviewLiturgyStateInput(content: '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts."}]'),
      ));
      await tester.pumpWidget(page, const Duration(milliseconds: 200) );
      expect(find.byType(PreviewContent), findsOneWidget);

      expect(findAppBarByTitle(page.getter.getPageTitle(PreviewLiturgyPage.titleRef)), findsOneWidget);

      checkButtons([page.getter.getButtonText(confirmButton), page.getter.getButtonText(previousButton), page.getter.getButtonText(cancelButton)]);

      // there is no error message
      checkFormError('');
    });

    testWidgets('When the user clicks the previous button the system invokes the previous event',
            (WidgetTester tester) async {
          MockPage page = MockPage(PreviewLiturgyPage(
            eventHandler: handler,
            inputState: MockPreviewLiturgyStateInput(content: '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts."}]'),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(previousButton), tester);
          expect(handler.lastEvent, UserJourneyController.backEvent);
        });

    testWidgets('When the user clicks the cancel button the system invokes the cancel event',
            (WidgetTester tester) async {
          MockPage page = MockPage(PreviewLiturgyPage(
            eventHandler: handler,
            inputState: MockPreviewLiturgyStateInput(content: '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts."}]'),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(cancelButton), tester);
          expect(handler.lastEvent, UserJourneyController.cancelEvent);
        });

    testWidgets('When the user clicks the confirm button the system invokes the confirm event',
            (WidgetTester tester) async {
          MockPage page = MockPage(PreviewLiturgyPage(
            eventHandler: handler,
            inputState: MockPreviewLiturgyStateInput(content: '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts."}]'),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(confirmButton), tester);
          expect(handler.lastEvent, UserJourneyController.confirmEvent);
        });

    /*


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

     */
  });
}

class MockPreviewLiturgyStateInput implements PreviewLiturgyStateInput {


  MockPreviewLiturgyStateInput({this.name = '', this.messageReference = '', this.content = ''});

  @override
  final String messageReference;

  @override
  final String name;

  @override
  final String content;
}