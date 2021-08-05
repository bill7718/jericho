

import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';

class MockUserNavigator implements UserJourneyNavigator {

  String currentRoute = '';
  int level = 0;
  StepInput? currentInput;
  String currentJourney = '';


  @override
  UserJourneyController getJourney(String route, SessionState session) {
    // TODO: implement getJourney
    throw UnimplementedError();
  }

  @override
  void goDownTo(dynamic context, String route, EventHandler handler, StepInput input) {
    currentRoute = route;
    currentInput = input;
    level++;
  }

  @override
  void goTo(dynamic context, String route, EventHandler handler, StepInput input) {
    currentRoute = route;
    currentInput = input;
  }

  @override
  void goUp(dynamic context) {
    level--;
  }

  @override
  void gotDownToNextJourney(dynamic context, String journeyRoute, SessionState session) {
    currentJourney = journeyRoute;
    currentRoute = '';
  }

  @override
  void gotoNextJourney(dynamic context, String journeyRoute, SessionState session) {
    currentJourney = journeyRoute;
    currentRoute = '';
  }

  @override
  Widget getPageWithoutJourney(String route) {
    // TODO: implement getPageWithoutJourney
    throw UnimplementedError();
  }

  @override
  void leaveJourney(context, String route) {
    currentRoute = route;
    currentJourney = '';
  }

}



class MockPersonalDetails extends PersonalDetailsStateOutput implements PersonalDetailsStateInput {
  @override
  final String email;

  @override
  final String name;


  @override
  final String messageReference;

  MockPersonalDetails(this.name, this.email, { this.messageReference = ''} );


}

class MockCapturePasswordStateOutput extends CapturePasswordStateOutput  {
  @override
  final String password;

  MockCapturePasswordStateOutput(this.password);

}

class MockCapturePasswordStateInput implements CapturePasswordStateInput {

  @override
  final String message;

  @override
  final String messageReference;

  @override
  final String password;

  MockCapturePasswordStateInput({this.password = '', this.messageReference = '', this.message = ''});

}

class MockEventHandler implements EventHandler {

  String lastEvent = '';
  StepOutput lastOutput = UserJourneyController.emptyOutput;

  @override
  Future<void> handleEvent(context, {String event = '', StepOutput output = UserJourneyController.emptyOutput}) {
    var c = Completer<void>();
    lastEvent = event;
    lastOutput = output;
    c.complete();
    return c.future;
  }

  @override
  void handleException(context, Exception ex, StackTrace? st) {
    // TODO: implement handleException
  }

}