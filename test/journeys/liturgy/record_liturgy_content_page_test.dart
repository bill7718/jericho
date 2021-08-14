import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/liturgy/liturgy.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_name_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/liturgy_services.dart';
import 'package:zefyrka/zefyrka.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();
  });

  group('Test Record Liturgy Content Page', () {
    testWidgets('When the system initiates Record Liturgy ContentPage the correct widgets are shown',
        (WidgetTester tester) async {
      MockPage page = MockPage(RecordLiturgyContentPage(
        eventHandler: handler,
        inputState: MockRecordLiturgyContentStateInput(name: 'Hello'),
      ));
      await tester.pumpWidget(page);

      expect(find.byType(ZefyrToolbar), findsOneWidget);
      expect(find.byType(ZefyrEditor), findsOneWidget);

      expect(findAppBarByTitle(page.getter.getPageTitle(RecordLiturgyContentPage.titleRef)), findsOneWidget);
      checkButtons([page.getter.getButtonText(nextButton), page.getter.getButtonText(previousButton), page.getter.getButtonText(cancelButton)]);

      // there is no error message
      checkFormMessage(page.getter.getScreenText(RecordLiturgyContentPage.initialMessage));
    });


    testWidgets('When the system initiates Record Liturgy Content with content in the input state then this name is shown',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordLiturgyContentPage(
            eventHandler: handler,
            inputState: MockRecordLiturgyContentStateInput(name: 'Brian' ,
          content: '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts."}]'),
          ));
          await tester.pumpWidget(page);

          expect(find.byWidgetPredicate((widget) => widget is ZefyrEditor && widget.controller.plainTextEditingValue.text.startsWith('Hear')), findsOneWidget);
        });

    testWidgets('When the user clicks the previous button the system invokes the previous event',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordLiturgyContentPage(
            eventHandler: handler,
            inputState: MockRecordLiturgyContentStateInput(),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(previousButton), tester);
          expect(handler.lastEvent, UserJourneyController.backEvent);
        });

    testWidgets('When the user clicks the cancel button the system invokes the cancel event',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordLiturgyContentPage(
            eventHandler: handler,
            inputState: MockRecordLiturgyContentStateInput(),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(cancelButton), tester);
          expect(handler.lastEvent, UserJourneyController.cancelEvent);
        });

    testWidgets(
        'When the user clicks the next button without any data input the system does not invoke an event and error messages are shown',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordLiturgyContentPage(
            eventHandler: handler,
            inputState: MockRecordLiturgyContentStateInput(),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, '');
          expect(find.text(page.getter.getErrorMessage(LiturgyValidator.contentError)), findsOneWidget);
        });

    testWidgets('When the user clicks the next button with valid input the next event is sent with the correct data',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordLiturgyContentPage(
            eventHandler: handler,
            inputState: MockRecordLiturgyContentStateInput(
                content: '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts."}]'
            ),
          ));
          await tester.pumpWidget(page);
          await tap(page.getter.getButtonText(nextButton), tester);
          expect(handler.lastEvent, UserJourneyController.nextEvent);
          var output = handler.lastOutput as RecordLiturgyContentStateOutput;
          expect(output.content, '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts."}]');
        });

    testWidgets('When the system created a Dynamic State object the listener on the controller updates the state',
            (WidgetTester tester) async {
        var state = RecordLiturgyContentDynamicState(content: '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts."}]');
        state.content = '';
        state.controller.notifyListeners();
        expect(state.content, '[{"insert":"Hear the commandments which God has given to his people, and examine your hearts."}]');

    });
  });
}

class MockRecordLiturgyContentStateInput implements RecordLiturgyContentStateInput {


  MockRecordLiturgyContentStateInput({this.name= '', this.content = '', this.messageReference = ''});

  @override
  final String messageReference;

  @override
  final String content;

  @override
  final String name;

  @override
  final controller = ZefyrController();
}
