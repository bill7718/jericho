library event_handler;

import 'package:jericho/journeys/user_journey_controller.dart';

abstract class EventHandler {

  Future<void> handleEvent( dynamic context,
      {String event = '', StepOutput output = UserJourneyController.emptyOutput});

  ///
  /// Process an Exception thrown by the Application
  ///
  void handleException(dynamic context, Exception ex, StackTrace? st );
}

abstract class StepOutput {

}

class EmptyStepOutput implements StepOutput {
  const EmptyStepOutput();
}


abstract class StepInput {

}

class EmptyStepInput implements StepInput {
  const EmptyStepInput();
}