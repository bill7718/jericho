

import 'package:flutter/material.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

abstract class EventHandler {

  Future<void> handleEvent( dynamic context,
      {String event = '', StepOutput output = UserJourneyController.emptyOutput});
}

abstract class StepOutput {

}

class EmptyStepOutput implements StepOutput {
  const EmptyStepOutput();
}


abstract class StepInput {

}