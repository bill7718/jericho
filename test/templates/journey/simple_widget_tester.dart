import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/journeys/liturgy/liturgy.dart';

import '../../mocks/mocks.dart';
import '../../util.dart';

void main() {
  MockEventHandler handler = MockEventHandler();
  setUp(() {
    handler = MockEventHandler();
  });

  group('Test New Organisation Page', () {
    testWidgets('When the system initiates New Organisation Page the correct widgets are shown',
            (WidgetTester tester) async {
          MockPage page = MockPage(RecordLiturgyNamePage(
            eventHandler: handler,
            inputState: MockRecordLiturgyNameStateInput(),
          ));
          await tester.pumpWidget(page);

          //expect(findAppBarByTitle(page.getter.getPageTitle(NewOrganisationPage.titleRef)), findsOneWidget);
          //checkTextInputFields([page.getter.getLabel(NewOrganisationPage.organisationNameLabel)]);
          //checkButtons([page.getter.getButtonText(nextButton), page.getter.getButtonText(previousButton)]);

          // there is no error message
          checkFormError('');
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
