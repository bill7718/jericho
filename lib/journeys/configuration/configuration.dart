

import 'package:jericho/journeys/register/personal_details_page.dart';

import 'constants.dart';



class ConfigurationGetter {

  Map<String, String> screenText = <String, String>{

    /// page titles
    PersonalDetailsPage.titleRef: 'Personal Details',

    /// labels
    email: 'Email Address',
    name: 'Name',

    /// button text
    next: 'Next',
    previous: 'Previous',
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

}