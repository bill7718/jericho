

import 'dart:async';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

class GenericJourney extends UserJourneyController {

  @override
  final String currentRoute;
  final StepInput input;
  final UserJourneyNavigator _navigator;

  GenericJourney(this._navigator, this.currentRoute, this.input);



  @override
  Future<void> handleEvent(context, {String event = '', StepOutput output = UserJourneyController.emptyOutput}) {

    var c = Completer<void>();

    print(output.toString());
    _navigator.goTo(context, currentRoute, this, input);

    c.complete();
    return c.future;
  }
}

class GenericJourneyInput {

  final String route;
  final StepInput input;

  GenericJourneyInput(this.route, this.input);
}

