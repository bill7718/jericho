import 'package:flutter_test/flutter_test.dart';
import 'package:jericho/general/constants.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/liturgy/record_liturgy_content_page.dart';
import 'package:jericho/journeys/organisation/confirm_organisation_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/validators.dart';

void main() {

  var getter = ConfigurationGetter();

  setUp(() async {

  });

  group('Test Configuration Getter', () {
    testWidgets('When I request page headings the correct value is returned  and when I request a value that is not configured I expect an empty string', (WidgetTester tester) async {

      expect(getter.getPageTitle(PersonalDetailsPage.titleRef), 'Personal Details');
      expect(getter.getPageTitle('dummy').isEmpty, true);
    });

    testWidgets('When I request screen text the correct value is returned  and when I request a value that is not configured I expect an empty string', (WidgetTester tester) async {

      expect(getter.getScreenText(RecordLiturgyContentPage.initialMessage).startsWith('Enter the content for the Liturgy here'), true);
      expect(getter.getScreenText('dummy').isEmpty, true);
    });

    testWidgets('When I request screen text and I include a parameter I expect it to be incorporated into the text', (WidgetTester tester) async {

      expect(getter.getScreenText(ConfirmOrganisationPage.confirmOrganisationTextRef, parameters: ['hello']).startsWith('You have been invited to to join hello.'), true);
      expect(getter.getScreenText('dummy').isEmpty, true);
    });

    testWidgets('When I request field labels the correct value is returned  and when I request a value that is not configured I expect an empty string', (WidgetTester tester) async {

      expect(getter.getLabel(nameLabel), 'Name');
      expect(getter.getLabel('dummy').isEmpty, true);
    });

    testWidgets('When I request button text the correct value is returned  and when I request a value that is not configured I expect an empty string', (WidgetTester tester) async {

      expect(getter.getButtonText(nextButton), 'Next');
      expect(getter.getButtonText('dummy').isEmpty, true);
    });

    testWidgets('When I requestan error message the correct value is returned  and when I request a value that is not configured I expect an empty string', (WidgetTester tester) async {

      expect(getter.getErrorMessage(Validator.nameError), 'Please provide a valid name.');
      expect(getter.getButtonText('dummy').isEmpty, true);
    });
  });
}
