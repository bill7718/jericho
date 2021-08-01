

import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/register/capture_password_page.dart';
import 'package:jericho/journeys/register/personal_details_page.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:jericho/services/user/user_services.dart';

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
  Widget getPage(String route, EventHandler handler, StepInput input) {
    // TODO: implement getPage
    throw UnimplementedError();
  }

  @override
  void goDownTo(dynamic context, String route, EventHandler handler, StepInput input) {
    currentRoute = route;
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
    // TODO: implement gotDownToNextJourney
  }

  @override
  void gotoNextJourney(dynamic context, String journeyRoute, SessionState session) {
    currentJourney = journeyRoute;
  }

}

class MockUserServices implements UserServices {

  String? email;
  String? name;

  @override
  Future<CreateUserResponse> createUser(CreateUserRequest request) {
    var c = Completer<CreateUserResponse>();
    if (request.password.contains('bad')) {
      c.complete(CreateUserResponse(false, message: 'bad password', reference: 'createFailed'));
    } else {
      c.complete(CreateUserResponse(true, userId: 'uid_' + request.email));
    }
    return c.future;
  }

  @override
  Future<ValidateUserResponse> validateUser(ValidateUserRequest request) {
    var c = Completer<ValidateUserResponse>();
    if (request.email.contains('bademail.com')) {
      c.complete(ValidateUserResponse(false, reference: duplicateUser));
    } else {
      c.complete(ValidateUserResponse(true));
    }
    return c.future;
  }



}

class MockPersonalDetailsOutput extends PersonalDetailsStateOutput {
  @override
  final String email;

  @override
  final String name;

  MockPersonalDetailsOutput(this.name, this.email);

}

class MockCapturePasswordStateOutput extends CapturePasswordStateOutput {
  @override
  final String password;

  MockCapturePasswordStateOutput(this.password);

}