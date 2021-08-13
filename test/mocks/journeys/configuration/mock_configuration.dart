import 'package:jericho/journeys/configuration/configuration_getter.dart';

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

  @override
  String getScreenText(String id, { List<String> parameters = const []}) {

    var response = 'screenText_$id';
    for (var item in parameters) {
      response = response + ':' + item;
    }

    return response;
  }

}