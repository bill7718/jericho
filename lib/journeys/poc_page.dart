import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jericho/journeys/configuration/configuration.dart';
import 'package:jericho/journeys/configuration/constants.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo_form_container.dart';
import 'package:waterloo/waterloo_form_message.dart';
import 'package:waterloo/waterloo_text_button.dart';
import 'package:zefyrka/zefyrka.dart';

///
/// The main Landing Page for the application
///
class POCPage extends StatelessWidget {
  static const String titleRef = 'landingPage';

  static const String inviteButtonTextRef = 'inviteButton';
  static const String createLiturgyButtonTextRef = 'createLiturgyButton';

  static const String inviteToOrganisationEvent = 'inviteUser';
  static const String createLiturgyEvent = 'createLiturgy';

  final EventHandler handler;

  const POCPage({Key? key, this.handler = const POCEventHandler()})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final getter = Provider.of<ConfigurationGetter>(context);
    GlobalKey key = GlobalKey();
    final error = FormError();
    ZefyrController controller = ZefyrController();

    return Scaffold(
        appBar: WaterlooAppBar.get(title: getter.getPageTitle(titleRef)),
        body: WaterlooFormContainer(formKey: key, children: <Widget>[
          WaterlooFormMessage(
            error: error,
          ),
          ZefyrEditor(controller: controller),
          WaterlooTextButton(
            text: getter.getButtonText(nextButton),
            exceptionHandler: handler.handleException,
            onPressed: () {
              handler.handleEvent(context, event: UserJourneyController.nextEvent);
            },
          )
        ]));
  }
}

class POCEventHandler implements EventHandler {
  const POCEventHandler();

  @override
  Future<void> handleEvent(context, {String event = '', StepOutput output = UserJourneyController.emptyOutput}) {
    var c = Completer<void>();
    c.complete();
    return c.future;
  }

  @override
  void handleException(context, Exception ex, StackTrace? st) {}
}
