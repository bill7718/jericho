

import 'package:jericho/journeys/register/personal_details_page.dart';



class ConfigurationGetter {

  Map<String, String> screenText = <String, String>{

    PersonalDetailsPage.titleRef: 'Personal Details'
  };

  String getPageTitle(String id) {
    return screenText[id] ?? '';
  }

}