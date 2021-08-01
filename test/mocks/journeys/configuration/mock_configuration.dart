

import 'package:jericho/journeys/configuration/configuration.dart';

class MockConfigurationGetter implements ConfigurationGetter {
  @override
  Map<String, String> screenText = <String, String>{};

  @override
  String getButtonText(String id)=>'button_$id';

  @override
  String getErrorMessage(String id)=>'error_$id';


  @override
  String getLabel(String id)=>'label_$id';

  @override
  String getPageTitle(String id)=>'title_$id';

}