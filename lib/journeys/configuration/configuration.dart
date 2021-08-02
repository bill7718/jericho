

import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/validators.dart';

import 'constants.dart';



class ConfigurationGetter implements ErrorMessageGetter {

  Map<String, String> screenText = <String, String>{

    /// page titles
    PersonalDetailsPage.titleRef: 'Personal Details',

    /// labels
    emailLabel: 'Email Address',
    nameLabel: 'Name',

    /// button text
    nextButton: 'Next',
    previousButton: 'Previous',


    /// error messages
    duplicateUser : 'This email address is already in use. Please try again.'
  };

  String getPageTitle(String id) {
    return screenText[id] ?? '';
  }

  String getLabel(String id) {
    return screenText[id] ?? '';
  }

  String getButtonText(String id) {
    return screenText[id] ?? '';
  }

  String getErrorMessage(String id) {
    return screenText[id] ?? '';
  }

}