import 'dart:async';

import 'package:flutter/material.dart';

import 'package:jericho/journeys/event_handler.dart';
import 'package:jericho/journeys/user_journey_controller.dart';
import 'package:waterloo/waterloo_form_container.dart';

///
/// The main Landing Page for the application
///
class POCPage extends StatelessWidget {
  static const String titleRef = 'landingPage';

  final EventHandler handler;

  const POCPage({Key? key, this.handler = const POCEventHandler()})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: WaterlooAppBar.get(title: 'Proof Of Concept'),
      body: Column(
        children: [
          Expanded(child: DragTarget(builder: (context, list, _) {
            return Container(
              color: Colors.blue ,
            );
          },
          onWillAccept: (data)=>true,
          onAccept: (data) {
            print(data.runtimeType.toString());
          },))
        ],
      ),
    );
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


