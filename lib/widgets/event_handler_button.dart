

import 'package:flutter/material.dart';
import 'package:jericho/journeys/event_handler.dart';
import 'package:waterloo/waterloo_text_button.dart';

class EventHandlerButton extends StatelessWidget {

  final String text;
  final String event;
  final EventHandler handler;

  EventHandlerButton({ Key? key, required this.text, required this.event, required this.handler}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return WaterlooTextButton(text: text, exceptionHandler: handler.handleException,
        onPressed: () {
          handler.handleEvent(context, event:  event);
        });
  }


}