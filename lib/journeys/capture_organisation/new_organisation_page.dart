




import 'package:jericho/journeys/event_handler.dart';

abstract class NewOrganisationStateInput implements StepInput {

  String get organisationName;
}

abstract class NewOrganisationStateOutput implements StepOutput {

  String get organisationName;
}

class NewOrganisationDynamicState implements NewOrganisationStateOutput {

  String organisationName = '';
}